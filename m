Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab2KXSYw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 13:24:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40399 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891Ab2KXSYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 13:24:51 -0500
Message-ID: <50B110CA.5000809@zytor.com>
Date: Sat, 24 Nov 2012 10:24:10 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v3 11/12] x86, boot: add fields to support load bzImage
 and ramdisk high
References: <1353482170-10160-1-git-send-email-yinghai@kernel.org> <1353482170-10160-12-git-send-email-yinghai@kernel.org> <50AD0CA1.8000904@zytor.com> <CAE9FiQUSjRT-r5ZE3WHVaKkUOhwFWkm9CTCv1Aa63DOsfMQMiQ@mail.gmail.com> <50AD291A.10600@zytor.com> <CAE9FiQVed0tXhbtmc_Gug0gFZ=s=j=N4B5Vr2_ZTmSj6L-65dw@mail.gmail.com> <a1ca794a-09d4-4d36-8c8c-67100cb3696e@email.android.com> <CAE9FiQXJO8uxT9Gzjv9e8XeiLzwBX7fwTFzDVy=oPfboG4L=3Q@mail.gmail.com> <CAE9FiQWeGz2TkLBrBZcoPrNABx51XK3xk58P+Zam_LRGoJdSiw@mail.gmail.com> <a8b15bf0-4e3b-4fde-9190-26890f9abf77@email.android.com> <CAE9FiQUoj9k0Tbqp8LC8Wb21_s_x8naiWX4zkX9pJG-oFnAQ9g@mail.gmail.com> <50AE70E7.6060204@zytor.com> <87haofi3d3.fsf@xmission.com> <50B104BC.90208@zytor.com> <CAE9FiQV0Q0fi7TrNjihdsUt0ueT4LLON4o+JEmX6ry9S6AU-ug@mail.gmail.com>
In-Reply-To: <CAE9FiQV0Q0fi7TrNjihdsUt0ueT4LLON4o+JEmX6ry9S6AU-ug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2012 10:12 AM, Yinghai Lu wrote:
>
> Now I have a fix ready, also found fix for kexec real mode path working
> with recently kernel by settin heap end ptr correctly.
>
> Please decide if we need to add 64 bit entry offset in setup header,
> Or just stick to 0x200.
>
> I check grub2 and gujin and qemu , looks like they are all using bzimage
> 16 bit entry.
>
> Do you have pointer for any boot loader that is using 64 bit entry in
> bzimage?
>

I'm fairly certain Grub2 does *not* use the 16-bit entry point by 
default even on BIOS platforms, needing the "linux16" directive to 
behave sanely (this is one of many complete facepalsm in Grub2).

efilinux or elilo compiled for a 64-bit EFI platform would be a good 
example, bit even if we can't find a 64-bit boot loader example I don't 
think we can rule one out, so let's just define 0x200 as an ABI constant 
and be done with it.  The cost is minimal and the consequences of 
changing it are potentially severe.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

