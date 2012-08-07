Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab2HGLSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:18:25 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:4795 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab2HGLSY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:18:24 -0400
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: RE: [PATCH] regmap-irq: allow auto-allocated IRQs to be mapped
Thread-Topic: [PATCH] regmap-irq: allow auto-allocated IRQs to be mapped
Thread-Index: AQHNckG72kyxY08IiEqTgpBfEDN7qZdONpdA
Date: Tue, 7 Aug 2012 11:18:20 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB51032C3B7E@NB-EX-MBX02.diasemi.com>
References: <201208020805.q72858Yj003147@latitude.olech.com>
 <20120804105424.GB10523@opensource.wolfsonmicro.com>
In-Reply-To: <20120804105424.GB10523@opensource.wolfsonmicro.com>
Accept-Language: en-GB, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.27.23]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if you don't TOP POST how can you tell who wrote what?

see my comments embedded below

-----Original Message-----
From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com] 
Sent: 04 August 2012 11:54
To: Opensource [Anthony Olech]
Cc: LKML; Anthony Olech; David Dajun Chen
Subject: Re: [PATCH] regmap-irq: allow auto-allocated IRQs to be mapped

On Wed, Aug 01, 2012 at 07:05:15PM +0100, Anthony Olech wrote:

> if the irq_base is set to -1 when calling regmap_add_irq_chip() then 
> allow the IRQ to be mapped even if the allocated irq_base is actually 
> zero.

> This restores the behaviour seen in v3.4, and I assume that the 
> tidy-ups just made in v3.5 INADVERTENTLY introduce this change in 
> behaviour.

Please pay MORE attention to the changelog - obviously there's no problem mapping automatically allocated IRQs, there's only any effect if they happen to GET allocated at zero.

That is the problem - they are allocated at zero, and hence my patch

The only real issue I see with the current code is that if the user explicitly wants to statically allocate an IRQ range at zero they can't.

I don't want to explicitly allocate at zero.

The current intended behaviour is that we use a linear domain unless a positive IRQ base is specified, though we're not quite doing that right now as a transitional measure until drivers are updated.

The fact remains that my patch enables the DA9058 driver to work in v3.5

The current da9052 driver usage seems to have quite a few problems, I do recall having to fix some problems that make me doubt if it ever worked well.  Looking at the code now I see it's using hard coded references to absolute IRQ numbers which is an issue...  It should be being converted to use regmap_irq_get_virq().
