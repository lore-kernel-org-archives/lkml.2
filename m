Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab0HaWSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 18:18:15 -0400
Received: from rrcs-208-125-96-138.nys.biz.rr.com ([208.125.96.138]:60147 "EHLO
	mail.kionix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab0HaWSN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 18:18:13 -0400
From: Chris Hudson <chudson@kionix.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Felipe Balbi <me@felipebalbi.com>, Hemanth V <hemanthv@ti.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "igor.stoppa@nokia.com" <igor.stoppa@nokia.com>,
        "kai.svahn@nokia.com" <kai.svahn@nokia.com>,
        "matthias.nyman@nokia.com" <matthias.nyman@nokia.com>
Date: Tue, 31 Aug 2010 18:21:33 -0400
Subject: RE: Sensors and the input layer (was Re: [RFC] [PATCH V2 1/2]
 input: CMA3000 Accelerometer driver)
Thread-Topic: Sensors and the input layer (was Re: [RFC] [PATCH V2 1/2]
 input: CMA3000 Accelerometer driver)
Thread-Index: ActJL+tRtp7hW0ssRSKXBwXuNQOO6gACdk0g
Message-ID: <4142B4ACE1A0344D9B6150EDE4AC4FE0B59D9BD4@K-Ex02.kionix2.com>
References: <36abcb34cfbf34724d9a581a75b53e76@secure211.sgcpanel.com>
 <20100830214025.2f9677a1@lxorguk.ukuu.org.uk>
 <20100830204412.GA28711@core.coreip.homeip.net>
 <AANLkTims1CagvPZQjTmYrOVi8REeLVbyyt3kEY_tsCtx@mail.gmail.com>
 <20100830214355.GB28865@core.coreip.homeip.net>
 <AANLkTinPConD62Ky7mvMn2ZgS=V9+Q5YUdaF5Vma8mn+@mail.gmail.com>
 <20100830224352.GF28865@core.coreip.homeip.net>
 <20100831104446.321fd4f4@lxorguk.ukuu.org.uk>
 <20100831161730.GA30947@core.coreip.homeip.net>
 <20100831175937.70a59a91@lxorguk.ukuu.org.uk>
 <20100831170923.GB30947@core.coreip.homeip.net>
In-Reply-To: <20100831170923.GB30947@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, so let's say we start moving some of the devices into input. Which
> ones we consider suitable for input? I guess some 3-digit
> accelerometers, what else? Also, what new event types would we need?
> Let's take GPS - I do not think that ABS_X and ABS_Y are the best events
> to be used for such devices: I am trying to allow applications being
> ignorant of what exact device they are talking to and rather concentrate
> on device capabilities (list of events supported). GPS is sufficiently
> different from a tablet/touchscreen; while some might want to use both
> as inputs to a game most applications would want to know which one
> which. 

> Also, GPS, liek ALS, would probably be polling, no?

> -- 
> Dmitry
> --

Hello Dmitry,

Current-generation accelerometers typically have some functions built-in that provide an interrupt signal under certain conditions.  For instance, orientation and motion detection can be calculated at the hardware level to reduce the need for constant polling and software to handle the algorithms.  Some devices have built-in tap detection, which can require data at several hundred samples per second, something that is certainly not efficiently supported in software.

I have been using ABS_MISC to pack 4 bytes of interrupt status information, but it might be a good idea to consider having a separate field for:
Orientation (screen rotation)
Motion Detection (or sleep detection)
Tap Detection

Regards,
Chris Hudson
