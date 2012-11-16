Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295Ab2KPH73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 02:59:29 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56235 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab2KPH71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 02:59:27 -0500
MIME-Version: 1.0
In-Reply-To: <20121115215529.GU2616@ZenIV.linux.org.uk>
References: <20121016223508.GR2616@ZenIV.linux.org.uk>
	<CACM3HyEpypULRWUc5ZnLnZ=uOWf3_j=9PXZiJrT_BXyGcQe9yg@mail.gmail.com>
	<CAHTX3dKDsOiUwtXxAUj-F4Y4rO+UZZDR4ufx_nxf+vuhmz46WA@mail.gmail.com>
	<20121017160702.GY2616@ZenIV.linux.org.uk>
	<20121017161953.GZ2616@ZenIV.linux.org.uk>
	<CAHTX3dJN4Jun2KVXpda1wTrwkjT0mmH4fYmUUwq69d9sCTjXnA@mail.gmail.com>
	<20121115215529.GU2616@ZenIV.linux.org.uk>
Date: Fri, 16 Nov 2012 08:59:25 +0100
Message-ID: <CAHTX3d+Ou3_4tGqwyWFfNMSumPw2770_nhV_cTQa89k7+sxdHw@mail.gmail.com>
Subject: Re: new execve/kernel_thread design
From: Michal Simek <monstr@monstr.eu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/15 Al Viro <viro@zeniv.linux.org.uk>:
> On Thu, Nov 15, 2012 at 05:41:16PM +0100, Michal Simek wrote:
>> Here is the branch based on rc5 (information below)
>> and here is giweb.
>> http://developer.petalogix.com/git/gitweb.cgi?p=linux-2.6-microblaze.git;a=shortlog;h=refs/heads/viro/arch-microblaze-rc5
>>
>> I have also looked at your sys_fork / sys_vfork / sys_clone unification
>> and I have fixed it for Microblaze.
>>
>> Also I have done some tests on it for sure.
>>
>> I would add sys_execve/kernel_execve/kernel_thread patches to my next branch.
>> Are you OK with that?
>
> Umm...  In principle - yes, but I've a couple of question abouts those.

sure.
BTW: that generic sys_fork / sys_vfork / sys_clone will go through your tree.


> 1) What's that set_fs(USER_DS) in start_thread() for?  Note that we do the same
> thing in flush_old_exec(), at the same time we remove PF_KTHREAD from
> current->flags.

ok. Will remove it.

> While we are at it, if we *ever* hit do_signal() with KERNEL_DS, we are
> very deep in trouble.  set_fs(USER_DS) in setup_{rt_,}frame() is pointless.

I have seen that several your signal patches around signal are there.

Do you have set of tests which should run it?


> 2) your definition of current_pt_regs() is an exact copy of on in
> include/linux/ptrace.h; why is "microblaze: Define current_pt_regs"
> needed at all?  IOW, I'd rather added #include <linux/ptrace.h> to
> arch/microblaze/kernel/process.c instead...

Agree. Fixed.

I have updated that branch or I can send you patches if you like.

Thanks,
Michal



-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
