Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab1HSB4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 21:56:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:46601 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab1HSB4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 21:56:23 -0400
Date: Fri, 19 Aug 2011 09:56:07 +0800
From: Yong Zhang <yong.zhang@windriver.com>
To: David Daney <david.daney@cavium.com>
CC: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] MIPS: use 32-bit wrapper for compat_sys_futex
Message-ID: <20110819015607.GA2798@windriver.com>
Reply-To: Yong Zhang <yong.zhang@windriver.com>
References: <1313546094-11882-1-git-send-email-yong.zhang@windriver.com>
 <4E4BF7C0.80703@cavium.com>
 <20110818023247.GA3750@windriver.com>
 <4E4D3C8D.1040707@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <4E4D3C8D.1040707@cavium.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [128.224.158.133]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 09:23:41AM -0700, David Daney wrote:
> On 08/17/2011 07:32 PM, Yong Zhang wrote:
> >On Wed, Aug 17, 2011 at 10:17:52AM -0700, David Daney wrote:
> >>>diff --git a/arch/mips/kernel/scall64-o32.S b/arch/mips/kernel/scall64-o32.S
> >>>index 46c4763..f48b18e 100644
> >>>--- a/arch/mips/kernel/scall64-o32.S
> >>>+++ b/arch/mips/kernel/scall64-o32.S
> >>>@@ -441,7 +441,7 @@ sys_call_table:
> >>>  	PTR	sys_fremovexattr		/* 4235 */
> >>>  	PTR	sys_tkill
> >>>  	PTR	sys_sendfile64
> >>>-	PTR	compat_sys_futex
> >>>+	PTR	sys_32_futex
> >>
> >>This change is redundant, scall64-o32.S already does the right thing
> >
> >My first virsion(not sent out) doesn't include scall64-o32.S either.
> >
> >>so additional zero extending is not needed and is just extra
> >>instructions to execute for no reason.
> >
> >Why I'm adding it here is for:
> >1)code consistent, otherwise we must move SYSCALL_DEFINE6(32_futex,...)
> >   under CONFIG_MIPS32_N32;
> 
> No, you don't have to move it.  Just don't call it.
> 
> 
> >2)I'm afraid there may be some other way to touch the high 32-bit of a
> >   register, so touching scall64-o32.S is also for safety(due to unknown
> >   reason, fix me if I'm wrong).
> 
> OK: You are mistaken.  You claim you don't understand what the code
> does.  That is really a poor justification for modifying it.

If you don't like it and you are sure there is no potential security problem,
just make a patch to remove it. Go ahead.

Thanks,
Yong
