Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760745Ab2EWSTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 14:19:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39005 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760650Ab2EWSTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 14:19:23 -0400
Date: Wed, 23 May 2012 19:19:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>
Subject: Re: linux-next: Tree for May 23 (uml)
Message-ID: <20120523181917.GN11775@ZenIV.linux.org.uk>
References: <20120523170740.ae058d8d5468d471eb948c39@canb.auug.org.au>
 <4FBD090E.5020901@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBD090E.5020901@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 08:58:06AM -0700, Randy Dunlap wrote:
> On 05/23/2012 12:07 AM, Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20120522:
> 
> 
> 
> uml defconfig on x86_64:
> 
> arch/um/kernel/process.c: In function 'interrupt_end':
> arch/um/kernel/process.c:122:14: error: 'struct task_struct' has no member named 'replacement_session_keyring'
> arch/um/kernel/process.c:123:4: error: implicit declaration of function 'key_replace_session_keyring'

Grr...  That's a conflict between uml gaining TIF_NOTIFY_RESUME (needed
prereq to task_work_add() series) and patch in said series doing away
with explicit calls of key_replace_session_keyring().  Fixup is to remove
those two lines in arch/um/process.c, same as done on other architectures
by "keys: kill the dummy key_replace_session_keyring()" (commit c1cb001).

Not an issue for mainline merge, since task_work_add patchset goes later,
but I think I'll have to cherry-pick that series into signal.git.  And
probably reorder it a bit, moving the calls into tracehook_notify_resume()
first, with "kill the dummy..." commit removing just that single call.
