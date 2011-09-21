Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633Ab1IUIdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 04:33:15 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:39575 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab1IUIdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 04:33:13 -0400
X-Auth-Info: iwyUmstsLZ1hDEsaiCGzHyYCnKpkGv8qoOzXZn7+4m4=
Message-ID: <4E79A146.2040204@grandegger.com>
Date: Wed, 21 Sep 2011 10:33:10 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: SocketCAN Core Mailing List <socketcan-core@lists.berlios.de>,
        Willy Lambert <lambert.willy@gmail.com>, x86@kernel.org,
        Valdis.Kletnieks@vt.edu, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: permit to configure ISA support also for x86_64
 systems
References: <4E731565.5050307@grandegger.com>	<63081.1316200771@turing-police.cc.vt.edu>	<4E73A419.70907@grandegger.com> <201109201747.50130.arnd@arndb.de>
In-Reply-To: <201109201747.50130.arnd@arndb.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2011 05:47 PM, Arnd Bergmann wrote:
> On Friday 16 September 2011, Wolfgang Grandegger wrote:
>> On 09/16/2011 09:19 PM, Valdis.Kletnieks@vt.edu wrote:
>>> On Fri, 16 Sep 2011 11:22:45 +0200, Wolfgang Grandegger said:
>>>> There are 64-bit systems out there, like the ATOM N450, which
>>>> have ISA slots.
>>>
>>> That's a scary thought...
>>
>> Well. Actually we need it for Intel Atom N450 PC/104-Plus SBCs.
> 
> I would assume that you have a small set of ISA add-on cards that
> you actually need to support, right?

Yes, various PC/104 compatible boards can be connected to the ISA bus on
such systems (via PC/104 connector). I personally do only care about the
CAN devices (as maintainer).

> Since most ISA drivers don't actually use isa_register_driver
> (for good or bad), how about changing the Kconfig entry for
> the ones you need to 'depends on ISA || PLAT_GRANDEGGER_PC104_ATOM'
> or similar?

What should the PLAT_GRANDEGGER_PC104_ATOM be good for? If I replace
isa_register_driver() with platform_driver_register(), like the serial
8250 driver does, HAS_IOMEM should be just fine. This would then also
avoid the 64-bit trouble expected with old ISA drivers (enabled via
ISA). Or have I missed something?

Wolfgang.
