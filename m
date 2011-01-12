Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab1ALDAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 22:00:31 -0500
Received: from h1047321.serverkompetenz.net ([85.214.67.163]:51852 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341Ab1ALDAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 22:00:30 -0500
Message-ID: <4D2D1942.4050905@ahsoftware.de>
Date: Wed, 12 Jan 2011 04:00:18 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Nicolas Pitre <nico@fluxnic.net>
Subject: Re: ARM: relocation out of range (when loading a module)
References: <4D2B4CE4.9080309@ahsoftware.de> <alpine.LFD.2.00.1101101722470.9794@xanadu.home> <4D2BFA08.5030104@ahsoftware.de> <AANLkTinR7ih2ZMRMbXmSvoh-rS3LVv+UCvd0rRH_ESzf@mail.gmail.com> <20110111155930.GH11039@n2100.arm.linux.org.uk>
In-Reply-To: <20110111155930.GH11039@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am 11.01.2011 16:59, schrieb Russell King - ARM Linux:
> On Tue, Jan 11, 2011 at 09:16:38PM +0530, Rabin Vincent wrote:
>> It's possible to hack around this by placing the initramfs at the end of
>> the kernel image rather than at the beginning with the rest of the init
>> data.  Something like the below should work, although you should also
>> probably take care of alignment and also have this section freed when
>> the rest of the init data is freed.
>
> You're then running into problems as _sdata.._edata is copied to RAM on
> XIP kernels, and you really don't want to waste time copying the
> initramfs to RAM.


Thanks to all for the provided informations. I'm now seeing some light. ;)

However, looking at the vmlinux.lds.S I think I should better not try to 
fix that, I would likely do something wrong because of missing knowledge 
about all those sections.

I can offer a patch wich adds a TODO to vmlinux.lds.S, but if someone 
else feels the need to fix that, feel free to do so. ;)

Regards,

Alexander


-------------------------------------------------------------------------
 From 2ce2934b6a55ac34734781d1a49569d79d0fdcda Mon Sep 17 00:00:00 2001
From: Alexander Holler <holler@ahsoftware.de>
Date: Wed, 12 Jan 2011 02:49:52 +0100
Subject: [PATCH] ARM: Add TODO to move INIT_RAM_FS to another point.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
  arch/arm/kernel/vmlinux.lds.S |    6 ++++++
  1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index cead889..5da3479 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -62,6 +62,12 @@ SECTIONS
                 INIT_CALLS
                 CON_INITCALL
                 SECURITY_INITCALL
+               /*
+                * TODO: The size of INIT_RAM_FS could easily reach a
+                * point (~16MB) when loading modules will fail because
+                * relocations will be out of range. So this place here
+                * isn't the best one.
+                */
                 INIT_RAM_FS

  #ifndef CONFIG_XIP_KERNEL
-- 
1.7.3.4
-------------------------------------------------------------------------
