Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290Ab2LVKid (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 05:38:33 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:38487 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab2LVKib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 05:38:31 -0500
MIME-Version: 1.0
In-Reply-To: <20121222024225.GG3468@phenom.dumpdata.com>
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
	<20121222024225.GG3468@phenom.dumpdata.com>
Date: Sat, 22 Dec 2012 02:38:29 -0800
X-Google-Sender-Auth: 9_XdxU2Z6ttAlGfmZgdNr4ke0Ew
Message-ID: <CAE9FiQV2HU+OpYmGH3Ttn103+-s=KgdokXGroZgooMSGMPJbsw@mail.gmail.com>
Subject: Re: [PATCH v7 00/27] x86, boot, 64bit: Add support for loading
 ramdisk and bzImage above 4G
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 6:42 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Mon, Dec 17, 2012 at 11:15:32PM -0800, Yinghai Lu wrote:
>> Now we have limit kdump reseved under 896M, because kexec has the limitation.
>> and also bzImage need to stay under 4g.
>>
>> To make kexec/kdump could use range above 4g, we need to make bzImage and
>> ramdisk could be loaded above 4g.
>> During booting bzImage will be unpacked on same postion and stay high.
>>
>> The patches add fields in setup_header and boot_params to
>> 1. get info about ramdisk position info above 4g from bootloader/kexec
>> 2. get info about cmd_line_ptr info above 4g from bootloader/kexec
>> 3. set xloadflags bit0 in header for bzImage and bootloader/kexec load
>>    could check that to decide if it could to put bzImage high.
>> 4. use sentinel to make sure ext_* fields in boot_params could be used.
>>
>> This patches is tested with kexec tools with local changes and they are sent
>> to kexec list later.
>>
>> could be found at:
>>
>>         git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-boot
>
> Did a light test and it looks to work under Xen - thought I had not tested
> any various configuration of memory layouts.
>
> More worryingly it blew up under native under an Dell T105 AMD box with 4GB of memory.
> I can't get it even to print anything on the serial log:

can you try that branch again ? update the #PF handler to clean
init_level4_pgt in all case.

I did not consider when you are xen enabled kernel on bare metal.

aka need to add
          clear_page(init_level4_pgt);

in init_mapping_kernel() of head_64.S

Thanks

Yinghai
