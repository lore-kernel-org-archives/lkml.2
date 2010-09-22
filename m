Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab0IVXM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 19:12:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54376 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab0IVXMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 19:12:23 -0400
Date: Thu, 23 Sep 2010 00:12:19 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Sparc
Message-ID: <20100922231219.GH19804@ZenIV.linux.org.uk>
References: <AANLkTi=pJUKRUQhpcVV8XAJF+BO1440v1Py5Opr34DR1@mail.gmail.com>
 <20100922195349.GF19804@ZenIV.linux.org.uk>
 <20100922204323.GG19804@ZenIV.linux.org.uk>
 <20100922.141514.232744402.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100922.141514.232744402.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 02:15:14PM -0700, David Miller wrote:

> Alternatively, #2 could be implemented using a special ptrace getregs
> call created specifically to fetch the windowed registers.  And
> the regset implementation of that could be used for dumping them
> into core files as well, and this specifically I've been meaning to
> do at some point.
> 
> Again, let me think about this some more.

OK... sparc32 question: just what the !@#!@# happens if sun4c_rett_stackchk
find (%fp & 7) != 0?  We go to ret_trap_user_stack_is_bolixed, which
tries to page in the underlying page.  OK, suppose it's already there and
readable; we return without doing anything - and go to signal_p.  Which finds
itself with nothing to do, and %fp is *still* buggered.  Spin ad infinitum?
srmmu_rett_stackchk will do the same, BTW...
