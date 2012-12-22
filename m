Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab2LVDBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 22:01:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41138 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab2LVDBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 22:01:46 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20121222024225.GG3468@phenom.dumpdata.com>
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org> <20121222024225.GG3468@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v7 00/27] x86, boot, 64bit: Add support for loading ramdisk and bzImage above 4G
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 21 Dec 2012 19:01:21 -0800
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Message-ID: <eee81bb9-f11b-4ff8-8a84-72f122766fd8@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Earlyprintk please?

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

>On Mon, Dec 17, 2012 at 11:15:32PM -0800, Yinghai Lu wrote:
>> Now we have limit kdump reseved under 896M, because kexec has the
>limitation.
>> and also bzImage need to stay under 4g.
>> 
>> To make kexec/kdump could use range above 4g, we need to make bzImage
>and
>> ramdisk could be loaded above 4g.
>> During booting bzImage will be unpacked on same postion and stay
>high.
>> 
>> The patches add fields in setup_header and boot_params to
>> 1. get info about ramdisk position info above 4g from
>bootloader/kexec
>> 2. get info about cmd_line_ptr info above 4g from bootloader/kexec
>> 3. set xloadflags bit0 in header for bzImage and bootloader/kexec
>load
>>    could check that to decide if it could to put bzImage high.
>> 4. use sentinel to make sure ext_* fields in boot_params could be
>used.
>> 
>> This patches is tested with kexec tools with local changes and they
>are sent
>> to kexec list later.
>> 
>> could be found at:
>> 
>>        
>git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
>for-x86-boot
>
>Did a light test and it looks to work under Xen - thought I had not
>tested
>any various configuration of memory layouts. 
>
>More worryingly it blew up under native under an Dell T105 AMD box with
>4GB of memory.
>I can't get it even to print anything on the serial log:
>
>(this is an excerpt from pxelinux.cfg/C0A8 file)
>LABEL BAREMETAL
>   KERNEL vmlinuz
>APPEND initrd=initramfs.cpio.gz debug selinux=0  loglevel=10 apic=debug
>console=uart8250,115200n8
>
>
>PXELINUX 3.82 2009-06-09  Copyright (C) 1994-2009 H. Peter Anvin et al
>Loading
>vmlinuz.......................................................................
>Loading
>initramfs.cpio.gz...........................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................!
 .........
................................................................................................................................................................................................................................................................................ready.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
