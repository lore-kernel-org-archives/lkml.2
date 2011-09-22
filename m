Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab1IVGn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 02:43:27 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:35727 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1IVGnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 02:43:24 -0400
X-Auth-Info: 2t2ECaTR6QwoF/w2FKnTBOdQpt2vxEMDUFngVexLX1w=
Message-ID: <4E7AD908.8060101@grandegger.com>
Date: Thu, 22 Sep 2011 08:43:20 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: SocketCAN Core Mailing List <socketcan-core@lists.berlios.de>,
        Willy Lambert <lambert.willy@gmail.com>, x86@kernel.org,
        Valdis.Kletnieks@vt.edu, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: permit to configure ISA support also for x86_64
 systems
References: <4E731565.5050307@grandegger.com> <201109201747.50130.arnd@arndb.de> <4E79A146.2040204@grandegger.com> <11382509.BgAkVknI9a@wuerfel>
In-Reply-To: <11382509.BgAkVknI9a@wuerfel>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2011 11:24 AM, Arnd Bergmann wrote:
> On Wednesday 21 September 2011 10:33:10 Wolfgang Grandegger wrote:
>>
>>> Since most ISA drivers don't actually use isa_register_driver
>>> (for good or bad), how about changing the Kconfig entry for
>>> the ones you need to 'depends on ISA || PLAT_GRANDEGGER_PC104_ATOM'
>>> or similar?
>>
>> What should the PLAT_GRANDEGGER_PC104_ATOM be good for? If I replace
>> isa_register_driver() with platform_driver_register(), like the serial
>> 8250 driver does, HAS_IOMEM should be just fine. This would then also
>> avoid the 64-bit trouble expected with old ISA drivers (enabled via
>> ISA). Or have I missed something?
> 
> I was thinking of the drivers that are for ISA cards but don't actually
> use the isa_register_driver() function. If you have to change the driver
> to a platform driver, you are right.

OK, then I will finally convert the sja1000_isa driver to a platform
driver instead of allowing CONFIG_ISA for x86_64.

> The other point is that you are probably using inb/outb operations,
> which I'm trying to provide only on ISA/PCMCIA/PCI based systems in
> the future. Once I finish that work, you will also need to depend on
> HAS_IOPORT (which currently means something else).

OK, the sja1000_isa driver just uses memory mapped access.

Wolfgang.
