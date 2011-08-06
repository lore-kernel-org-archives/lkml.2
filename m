Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab1HFR4D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 13:56:03 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:58624 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401Ab1HFR4B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 13:56:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAHFgRy_5FPJn0a9Z6uNdCLUBd5SPac9F_Fhymdc66yeso9=Scw@mail.gmail.com>
References: <CAHFgRy_5FPJn0a9Z6uNdCLUBd5SPac9F_Fhymdc66yeso9=Scw@mail.gmail.com>
Date: Sat, 6 Aug 2011 19:56:00 +0200
Message-ID: <CAKWSe6Az_tFvG+S31pKW4ciEh_Nax5WVS490B1UHyiZ1maSh1w@mail.gmail.com>
Subject: =?windows-1252?Q?Re=3A_3=2E0=2E0=2Dgit21_=2D=2D_CC_fs=2Fbinfmt=5Fmisc=2Eo_=2E=2E=2E=2Fasm=2Fuacce?=
	=?windows-1252?Q?ss=5F32=2Eh=3A211=3A26=3A_error=3A_call_to_=91copy=5Ffrom=5Fuser=5Foverflow=92?=
	=?windows-1252?Q?_declared_with_attribute_error=3A_copy=5Ffrom=5Fuser=28=29_buffer_size?=
	=?windows-1252?Q?_is_not_provably_correct?=
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 6, 2011 at 7:49 PM, Miles Lane <miles.lane@gmail.com> wrote:
> I am not finding any kernel configuration that enables me to avoid
> this compile error.  Anyone know what I can do to successfully build
> this kernel?
>
> On Fri, Aug 5, 2011 at 1:15 PM, Miles Lane <miles.lane@gmail.com> wrote:
>> CC      fs/binfmt_misc.o
>> In file included from /usr/src/linux-3.0/arch/x86/include/asm/uaccess.h:573:0,
>>                 from include/linux/uaccess.h:5,
>>                 from include/linux/highmem.h:7,
>>                 from include/linux/pagemap.h:10,
>>                 from fs/binfmt_misc.c:26:
>> /usr/src/linux-3.0/arch/x86/include/asm/uaccess_32.h: In function
>> ‘parse_command.part.1’:
>> /usr/src/linux-3.0/arch/x86/include/asm/uaccess_32.h:211:26: error:
>> call to ‘copy_from_user_overflow’ declared with attribute error:
>> copy_from_user() buffer size is not provably correct

Well, uaccess_32.h has this:

extern void copy_from_user_overflow(void)
#ifdef CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
    __compiletime_error("copy_from_user() buffer size is not provably correct")
#else
    __compiletime_warning("copy_from_user() buffer size is not provably correct"
)
#endif

 and you have CONFIG_DEBUG_STRICT_USER_COPY_CHECKS=y.

ciao,

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
