Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab0DHOxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 10:53:55 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33599 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758609Ab0DHOxx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 10:53:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Te+O/PliMsBOR9ZMbEzSIC58tNseZspmdK81LuiOOSE+v1FMoq2dWSP36x1DbQA17Z
         bXXe3ffK+QhtfofXvckPO7P292ExUwDR1UOglS5OrHBskxy6mmX9qVURqTR57i4NS2ug
         FFqXsB3NqJgBz/4bgZL6UaDugDZ6ePcNc0J80=
MIME-Version: 1.0
In-Reply-To: <4BBD7997.1020803@ladisch.de>
References: <x2w5bdc1c8b1004051355o3f803c75t2515ef46320e00bd@mail.gmail.com>
	 <4BBC9CA1.5080102@ladisch.de>
	 <m2l5bdc1c8b1004070857r823821ack6cc99354db73eaa0@mail.gmail.com>
	 <4BBD1957.90502@gmail.com>
	 <k2l5bdc1c8b1004072051h957c3f1crf0a139bd96a093a4@mail.gmail.com>
	 <v2h51f3faa71004072054y4733bf9bq80a04574bebbadba@mail.gmail.com>
	 <4BBD7997.1020803@ladisch.de>
Date: Thu, 8 Apr 2010 07:53:53 -0700
Message-ID: <l2v5bdc1c8b1004080753k7787e635p4a70d4a1a777984d@mail.gmail.com>
Subject: Re: Failed to initialize MSI interrupts && ioremap reserve_memtype 
	failed -22
From: Mark Knecht <markknecht@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Robert Hancock <hancockrwd@gmail.com>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 7, 2010 at 11:37 PM, Clemens Ladisch <clemens@ladisch.de> wrote:
> Robert Hancock wrote:
>> Hmm, not really clear to me why MSI wouldn't be used.. there aren't
>> any kernel messages that seem to say why MSI would be disabled or
>> unsupported. Unless maybe that particular model doesn't support MSI?
>
> This Intel onboard adapter always supports MSI, and AFAICS there is no
> MSI quirk for this chipset.
>
> Mark, is CONFIG_PCI_MSI actually enabled?
>
>> > ioremap reserve_memtype failed -22
>
> ioremap is used by drivers (and sometimes by the kernel itself) to get
> access to some device's memory-mapped I/O range.  "-22" is -EINVAL and
> is returned by reserve_memtype to indicate that the requested memory
> range includes both RAM and not-RAM.
>
> Without a following error message, it's not possible to find out which
> device that is, and where that funny address range comes from.  The fact
> that there is no error message might indicate that this is harmless, but
> if you want to find out more, add the following lines to
> arch/x86/mm/ioremap.c directly after the error message:
>
>                printk(KERN_ERR "phys_addr: %#Lx, size: %#Lx\n",
>                       (u64)phys_addr, (u64)size);
>                dump_stack();
>
>
> Regards,
> Clemens
>

Indeed, MSI was not enabled so turning it on got rid of the MSI message.

Here is the new stuff in dmesg from the code stub above:

Adding 4200988k swap on /dev/sda2.  Priority:-1 extents:1
across:4200988k
Adding 4200988k swap on /dev/sdb2.  Priority:-2 extents:1
across:4200988k
Adding 4200988k swap on /dev/sdc2.  Priority:-3 extents:1
across:4200988k
e1000e 0000:00:19.0: irq 31 for MSI/MSI-X
e1000e 0000:00:19.0: irq 31 for MSI/MSI-X
e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: 10/100 speed: disabling TSO
NET: Registered protocol family 10
ioremap reserve_memtype failed -22
phys_addr: 0xcf7fe000, size: 0x2000
Pid: 3897, comm: X Tainted: P           2.6.33-gentoo #4
Call Trace:
 [<ffffffff8101b7ee>] ? __ioremap_caller+0x1e2/0x30e
 [<ffffffffa052345b>] ? _nv006553rm+0x3a/0x40 [nvidia]
 [<ffffffffa052345b>] ? _nv006553rm+0x3a/0x40 [nvidia]
 [<ffffffffa04ab215>] ? _nv007450rm+0xa0/0x1e4 [nvidia]
 [<ffffffffa04ab4d3>] ? _nv007499rm+0x76/0xb3 [nvidia]
 [<ffffffffa04a79f1>] ? _nv007478rm+0xc8/0x325 [nvidia]
 [<ffffffffa04a7cf8>] ? _nv007428rm+0xaa/0x19a [nvidia]
 [<ffffffffa04a7e38>] ? _nv007479rm+0x50/0x5d [nvidia]
 [<ffffffffa04b47cf>] ? _nv007487rm+0x6e/0x78 [nvidia]
 [<ffffffffa052fec8>] ? _nv010998rm+0x69/0x121 [nvidia]
 [<ffffffffa052fe46>] ? _nv010944rm+0xde/0xf7 [nvidia]
 [<ffffffffa04abb9a>] ? _nv025178rm+0x68/0x194 [nvidia]
 [<ffffffffa04ccc1f>] ? _nv014218rm+0x177/0x45c [nvidia]
 [<ffffffffa04cc20f>] ? _nv013795rm+0xc9/0x13a [nvidia]
 [<ffffffffa039d9b8>] ? _nv014028rm+0xd/0x12 [nvidia]
 [<ffffffffa052fbf5>] ? _nv004517rm+0x160/0x26f [nvidia]
 [<ffffffffa05309fd>] ? _nv004523rm+0x47e/0x651 [nvidia]
 [<ffffffffa052b31a>] ? rm_init_adapter+0x69/0xbd [nvidia]
 [<ffffffffa0618f27>] ? nv_kern_open+0x4f5/0x640 [nvidia]
 [<ffffffff8108cbef>] ? chrdev_open+0x190/0x1af
 [<ffffffff8108ca5f>] ? chrdev_open+0x0/0x1af
 [<ffffffff81088ac8>] ? __dentry_open+0x19d/0x2b9
 [<ffffffff81095307>] ? do_filp_open+0x504/0xa96
 [<ffffffff8103669a>] ? capable+0x22/0x41
 [<ffffffff8109d1fe>] ? notify_change+0x2b3/0x2c5
 [<ffffffff8109db43>] ? alloc_fd+0x112/0x123
 [<ffffffff81088853>] ? do_sys_open+0x55/0x102
 [<ffffffff81001f6b>] ? system_call_fastpath+0x16/0x1b
eth0: no IPv6 routers present
mark@k2 ~ $

Hopefully I put it in the way you intended me to do:

        if (retval) {
                printk(KERN_ERR "ioremap reserve_memtype failed %d\n", retval);

                printk(KERN_ERR "phys_addr: %#Lx, size: %#Lx\n",
                        (u64)phys_addr, (u64)size);
                dump_stack();
                return NULL;
        }

Seems like maybe you would want symbols or something. If so then
please let me know how to turn that on and I'll give it a try.

Thanks,
Mark
