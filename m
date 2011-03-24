Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933669Ab1CXIGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 04:06:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63261 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933179Ab1CXIGK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 04:06:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vtIJkc6JsrSwk+MSiK92BtJCSPZYPaxbFDDFoCnxOq7RfSEAa7I9uMBPzF3Dvjjno7
         SPD+AYWkzFjB8WI2yJFcKmJlqXOGq4vzQDwPrzEEROgDWyeTeHvDaJsttonpT17tf9YX
         EAtqrT18NJ9ZCrO3sc5dHsNuDQkGASiWLWuvg=
MIME-Version: 1.0
In-Reply-To: <4D8A7B7F.2050405@snapgear.com>
References: <1300768985-902-1-git-send-email-gerg@snapgear.com>
	<AANLkTimHzPn2Xe1RVRQKjwdynDvc3iL2=8kJ1p8kRZQ4@mail.gmail.com>
	<4D8A7B7F.2050405@snapgear.com>
Date: Thu, 24 Mar 2011 09:06:08 +0100
X-Google-Sender-Auth: mG_ld_SZ8o1yZoAysN_lU4srmVY
Message-ID: <AANLkTik37qYtMOWENPvRmhqqPkUCTL79_cqZ-0e_i2o7@mail.gmail.com>
Subject: Re: [PATCH 0/1] m68k: merge m68k and m68knommu arch directories
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux-m68k@vger.kernel.org, uclinux-dev@uclinux.org,
        linux-kernel@vger.kernel.org, Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thu, Mar 24, 2011 at 00:00, Greg Ungerer <gerg@snapgear.com> wrote:
> On 24/03/11 08:07, Geert Uytterhoeven wrote:
>> On Tue, Mar 22, 2011 at 05:43,<gerg@snapgear.com>  wrote:
>>> slso on the for-next branch in that tree, so will get some testing
>>> in the next tree for the next few days.
>>
>> defconfig is now a nommu-config, and it fails?
>>
>> http://kisskb.ellerman.id.au/kisskb/buildresult/4012794/
>
> Yep, that looks wrong. I'll move the define for KBUILD_DEFCONFIG
> into arch/m68k/Makefile (and remove the existing defines in Makefile_mm
> and Makefile_no). That will make the DEFCONFIG as it was before,
> multi_defconfig.
>
>> arch/m68k/kernel/entry_no.S:47: Error: Unknown operator -- statement
>> `save_all' ignored
>
> This is due to compiling for the non-mmu targets and not using
> a m68k-uclinux- toolchain. Unfortunately the compiler must define
> __uClinux__ to compile for non-mmu targets. This isn't new, we

For userland...

> have had this problem ever since the merge of the header files.
> (The exported headers need some switch to use to base some
> conditionals on, and kernel config options cannot be used in
> exported headers).

For kernels, we can explicitly define this in arch/m68k/Makefile if !MMU, right?

> But with a fixed defconfig, you won't see this anymore :-)
>
> I'll fix up the git commit on m68knommu git tree.

Good, thx!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
