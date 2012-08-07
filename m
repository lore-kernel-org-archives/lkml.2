Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab2HGOhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 10:37:41 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:53585 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996Ab2HGOhk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 10:37:40 -0400
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: RE: [PATCH] regmap-irq: allow auto-allocated IRQs to be mapped
Thread-Topic: [PATCH] regmap-irq: allow auto-allocated IRQs to be mapped
Thread-Index: AQHNckG72kyxY08IiEqTgpBfEDN7qZdONpdAgAAe5ICAABLO8A==
Date: Tue, 7 Aug 2012 14:37:37 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB51032C3C2A@NB-EX-MBX02.diasemi.com>
References: <201208020805.q72858Yj003147@latitude.olech.com>
 <20120804105424.GB10523@opensource.wolfsonmicro.com>
 <24DF37198A1E704D9811D8F72B87EB51032C3B7E@NB-EX-MBX02.diasemi.com>
 <20120807140311.GH16861@opensource.wolfsonmicro.com>
In-Reply-To: <20120807140311.GH16861@opensource.wolfsonmicro.com>
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

> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: 07 August 2012 15:03
> On Tue, Aug 07, 2012 at 11:18:20AM +0000, Opensource [Anthony Olech]
> wrote:
> > if you don't TOP POST how can you tell who wrote what?
> Well, it's not clear who wrote what in your current e-mail since there's no
> indication of what's quoted and what's new text...  Take a look at all the other
> mails on the list - your mail should be in a similar style to them.  There's some
> advice for common e-mail clients in email-clients.txt under Documentation.

I found the option to quote/indent the email original, sorry about that but we
are forced to use Microsoft Outlook and the default were set up strangely.
 
> The bottom line here is that if your driver requires a dynamically allocated
> legacy domain it is broken.

I am trying to use the latest REGMAP API, and I do not understand why you
say the DSA9058 driver "requires" a dynamically allocated legacy domain.
Surely the virtual IRQs that the PMIC component drivers use must be
dynamically allocated. It is only the single GPIO line designated as an
interrupt line in the machne drivert that is fixed by the hardware. That
surely means the "irq_base" parameter to regmap_add_irq_chip() must
be set to "-1". What else could it be set to??

I am beginning to suspect that I have misunderstood something. The
regmap-irq API seemed taylor-made for our PMIC with one real h/w
interrupt line with several PMIC chip irq sources controlled by a set
of registers that seemed to slot into the "regmap_add_irq_chip" struct
perfectly. Why should that set of virtual irqs be given a specific base??

I really hope that you can help me clear this issue up, as there are not
many examples of drivers that use the regmap-irq API in linux-release
GIT repository.

Tony Olech




