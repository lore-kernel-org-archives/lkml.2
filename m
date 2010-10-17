Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab0JQI4W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 04:56:22 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63094 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197Ab0JQI4V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 04:56:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=QBchINqX1rkLew/Sx62sGwbAZkRzr1b195v1RcFc8P9eAaQy4Er83UKABTkmHBxzZh
         I/FgKHC2ec+R+WYL36JY+/2n4GADc6KnnwqcAihjmuN78KikWm+dy61VEWj18H0cUEOF
         xH0QeUdq9FtQ2BWjyvY/Cvdp3azbjAyhm86GE=
MIME-Version: 1.0
In-Reply-To: <20101017085416.GA1758@darkstar>
References: <20101017085416.GA1758@darkstar>
Date: Sun, 17 Oct 2010 16:56:11 +0800
Message-ID: <AANLkTim8jnypOuSjAJP23adGLMcb2-107a6z7gm_d4oL@mail.gmail.com>
Subject: Re: [BUG] kvm: guest can not startup due to triple fault
From: Dave Young <hidave.darkstar@gmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 4:54 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> linux guest can not startup normally, qemu keep rebooting.
>
> host & guest both use linux-2.6.36-rc8+ kernel

BTW,  qemu cmdline with -kernel will more likely trigger this bug

>
> Add a dump_stack in x86.c around EXIT_SHUTDOWN code, I got:
> [ 3924.503041] Pid: 1685, comm: qemu-system-x86 Not tainted 2.6.36-rc8+ #62
> [ 3924.503045] Call Trace:
> [ 3924.503055]  [<ffffffffa0176047>] handle_triple_fault+0x11/0x26 [kvm_intel]
> [ 3924.503060]  [<ffffffffa01772d2>] vmx_handle_exit+0x3df/0x474 [kvm_intel]
> [ 3924.503080]  [<ffffffffa021f203>] kvm_arch_vcpu_ioctl_run+0x95f/0xc43 [kvm]
> [ 3924.503087]  [<ffffffff81503e54>] ? __mutex_unlock_slowpath+0x11c/0x131
> [ 3924.503101]  [<ffffffffa021e1f9>] ? kvm_arch_vcpu_load+0x90/0xe6 [kvm]
> [ 3924.503112]  [<ffffffffa0210faf>] kvm_vcpu_ioctl+0x109/0x54a [kvm]
> [ 3924.503117]  [<ffffffff810bee76>] ? fire_user_return_notifiers+0x2c/0x36
> [ 3924.503122]  [<ffffffff8106be93>] ? trace_hardirqs_on+0xd/0xf
> [ 3924.503127]  [<ffffffff81002789>] ? do_notify_resume+0x717/0x73d
> [ 3924.503131]  [<ffffffff8103994e>] ? finish_task_switch+0x69/0xda
> [ 3924.503135]  [<ffffffff8110628c>] do_vfs_ioctl+0x4c3/0x50d
> [ 3924.503139]  [<ffffffff8110632b>] sys_ioctl+0x55/0x77
> [ 3924.503142]  [<ffffffff81002c02>] system_call_fastpath+0x16/0x1b
>
> Anyone can help on this?
>



-- 
Regards
dave
