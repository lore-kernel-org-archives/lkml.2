Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab0JQKOK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 06:14:10 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34895 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234Ab0JQKOJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 06:14:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YJexgOt1C1wLBzJE+cNZJucsscAtfoA94N01UZVlCJsSQzZHalq5rt8VbqLn+nzNSW
         F3aH1yCI6AjAKKDX/TR3Dy4h2pAqh3VJomQ/5Ill04X3AN6uAx/RXRJe585bVPIK/Bkf
         O7DYwUHgipJrBO04T3aaKc6FjL+94Mx/5YEfc=
MIME-Version: 1.0
In-Reply-To: <4CBAC342.1010609@redhat.com>
References: <20101017085416.GA1758@darkstar>
	<4CBAC342.1010609@redhat.com>
Date: Sun, 17 Oct 2010 18:14:07 +0800
Message-ID: <AANLkTin6qJYEqOc_97EVWkK1Kt1zNSvXtfVeYuk9fyJ8@mail.gmail.com>
Subject: Re: [BUG] kvm: guest can not startup due to triple fault
From: Dave Young <hidave.darkstar@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 5:34 PM, Avi Kivity <avi@redhat.com> wrote:
>  On 10/17/2010 10:54 AM, Dave Young wrote:
>>
>> linux guest can not startup normally, qemu keep rebooting.
>>
>> host&  guest both use linux-2.6.36-rc8+ kernel
>>
>> Add a dump_stack in x86.c around EXIT_SHUTDOWN code, I got:
>> [ 3924.503041] Pid: 1685, comm: qemu-system-x86 Not tainted 2.6.36-rc8+
>> #62
>> [ 3924.503045] Call Trace:
>> [ 3924.503055]  [<ffffffffa0176047>] handle_triple_fault+0x11/0x26
>> [kvm_intel]
>> [ 3924.503060]  [<ffffffffa01772d2>] vmx_handle_exit+0x3df/0x474
>> [kvm_intel]
>> [ 3924.503080]  [<ffffffffa021f203>] kvm_arch_vcpu_ioctl_run+0x95f/0xc43
>> [kvm]
>> [ 3924.503087]  [<ffffffff81503e54>] ? __mutex_unlock_slowpath+0x11c/0x131
>> [ 3924.503101]  [<ffffffffa021e1f9>] ? kvm_arch_vcpu_load+0x90/0xe6 [kvm]
>> [ 3924.503112]  [<ffffffffa0210faf>] kvm_vcpu_ioctl+0x109/0x54a [kvm]
>> [ 3924.503117]  [<ffffffff810bee76>] ?
>> fire_user_return_notifiers+0x2c/0x36
>> [ 3924.503122]  [<ffffffff8106be93>] ? trace_hardirqs_on+0xd/0xf
>> [ 3924.503127]  [<ffffffff81002789>] ? do_notify_resume+0x717/0x73d
>> [ 3924.503131]  [<ffffffff8103994e>] ? finish_task_switch+0x69/0xda
>> [ 3924.503135]  [<ffffffff8110628c>] do_vfs_ioctl+0x4c3/0x50d
>> [ 3924.503139]  [<ffffffff8110632b>] sys_ioctl+0x55/0x77
>> [ 3924.503142]  [<ffffffff81002c02>] system_call_fastpath+0x16/0x1b
>>
>> Anyone can help on this?
>
> Please provide a trace (trace-cmd record -e kvm) leading to the failure.
>

Hi, please see:
http://userweb.kernel.org/~davey/tmp/trace.dat

> --
> error compiling committee.c: too many arguments to function
>
>



-- 
Regards
dave
