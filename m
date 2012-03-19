Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878Ab2CSWjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 18:39:48 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39476 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871Ab2CSWjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 18:39:47 -0400
Date: Tue, 20 Mar 2012 02:39:41 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [patch 1/2] c/r: prctl: Add ability to set new
 mm_struct::exe_file
Message-ID: <20120319223941.GJ19594@moon>
References: <20120316205556.595309230@openvz.org>
 <20120316210343.925446961@openvz.org>
 <20120319151507.93bab32a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319151507.93bab32a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 03:15:07PM -0700, Andrew Morton wrote:
...
> > 
> > Also this action is one-shot only. For security reason
> > we don't allow to change the symlink several times.
> 
> What is this mysterious "security reason"?
> 

Oh, sorry I should have included Matt's comment here

	| Before this patch that state was rather ephemeral and almost entirely
	| under the control of the kernel. The only way userspace could change it
	| was by unmapping the region(s) mapped during exec*(). At that point it
	| could not "lie" and insert some other symlink there and the admin would
	| be better able to determine what had happened.
	|
	| With this patch -- especially the multi-shot form -- the symlink will
	| be entirely under the control of (potentially untrusted) userspace code
	| and the admin is totally at the mercy of the userspace code. In
	| single-shot form programs could use the prctl() to ensure the symlink
	| could not be changed later -- the restart tool would be the only program
	| that would need to ensure that prctl() had not been used since the last
	| exec*().
...
> 
> It should be explained here also.  The comment is pretty useless - if
> we don't tell people what this "security reason" is, how can future
> developers be sure that they aren't violating it?
> 

Actually I liked multi-shot version more but Matt arguments convinced
me that one-short fashion is more "secure" in terms of overall kernel
state and potential transitions/changes of this /proc/pid/exe symlink.

At least with one-shot version the admin may be sure that the symlink
is never changed more than once, ever.

	Cyrill
