Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab0K0NB1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 08:01:27 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36492 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab0K0NBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 08:01:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RR5pxVIDRc980VjRr2UtMpskHmoa37IGaUn4Ox2aAlGaNO82C9HbM0oNiv5lGIxAc9
         DH0u7l3xYOLyAmy6hZRQXI4OrnA2Nn+lR8y9yc8kMlIQ1Byk/N3a23kBm3wRyDZuR/vq
         kK/K31j8u9gW6GojWHRdjxggGb1+gQYNO0fVM=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1011271306420.7659@localhost.localdomain>
References: <1290263224-16965-1-git-send-email-ulli.kroll@googlemail.com>
	<AANLkTikkVqWgpYEg505DwQ+pSegQv1g-Q8cDEpE-JCrV@mail.gmail.com>
	<alpine.LNX.2.00.1011271306420.7659@localhost.localdomain>
Date: Sat, 27 Nov 2010 14:01:20 +0100
Message-ID: <AANLkTinbAVFE+HZrx+9KUwx8=MKFHPqrhpOpAWAEQFv-@mail.gmail.com>
Subject: Re: [PATCH] ARM: Gemini: Add support for PCI Bus
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
To: Hans Ulli Kroll <ulli.kroll@googlemail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 27 listopada 2010 13:16 u¿ytkownik Hans Ulli Kroll
<ulli.kroll@googlemail.com> napisa³:
> On Fri, 26 Nov 2010, Micha³ Miros³aw wrote:
>> 2010/11/20 Hans Ulli Kroll <ulli.kroll@googlemail.com>:
>> > Add support for PCI Bus on Gemini Devices SL3516
>> >
>> > Signed-off-by: Hans Ulli Kroll <ulli.kroll@googlemail.com>
>> > ---
>> [...]
>> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> > index a19a526..5d4b398 100644
>> > --- a/arch/arm/Kconfig
>> > +++ b/arch/arm/Kconfig
>> > @@ -307,6 +307,7 @@ config ARCH_GEMINI
>> >        select CPU_FA526
>> >        select ARCH_REQUIRE_GPIOLIB
>> >        select ARCH_USES_GETTIMEOFFSET
>> > +       select PCI
>> >        help
>> >          Support for the Cortina Systems Gemini family SoCs
>> >
>> [...]
>> I think it's better to add ARCH_GEMINI to CONFIG_PCI dependencies.
>> AFAIK IB-4220B NAS does not use PCI and doesn't need all that code.
>> Board support entries could select PCI if the board is useless without
>> it.
> I know this, I have some.
>
> There are many boards with PCI i.e WBD 222.
> Other ARM devices uses the same select inside ARCH_*
> I don't want to pollute drivers/pci/Kconfig.

I meant 'config PCI' entry in arch/arm/Kconfig, see following diff.

Best Regards,
Micha³ Miros³aw

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index db524e7..74ea522 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1164,7 +1164,7 @@ config ISA_DMA_API
 	bool

 config PCI
-	bool "PCI support" if ARCH_INTEGRATOR_AP || ARCH_VERSATILE_PB ||
ARCH_IXP4XX || ARCH_KS8695 || MACH_ARMCORE || ARCH_CNS3XXX
+	bool "PCI support" if ARCH_INTEGRATOR_AP || ARCH_VERSATILE_PB ||
ARCH_IXP4XX || ARCH_KS8695 || MACH_ARMCORE || ARCH_CNS3XXX ||
ARCH_GEMINI
 	help
 	  Find out whether you have a PCI motherboard. PCI is the name of a
 	  bus system, i.e. the way the CPU talks to the other stuff inside
