Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab0FXFK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 01:10:27 -0400
Received: from fallback.mail.timico.net ([62.121.11.168]:44108 "EHLO
	fallback.mail.timico.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab0FXFKZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 01:10:25 -0400
X-Greylist: delayed 1958 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jun 2010 01:10:24 EDT
From: Jon Povey <Jon.Povey@racelogic.co.uk>
To: Jamie Lokier <jamie@shareable.org>, Ryan Mallon <ryan@bluewatersys.com>
CC: David Brownell <dbrownell@users.sourceforge.net>,
       linux kernel <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Class: urn:content-classes:message
Date: Thu, 24 Jun 2010 05:33:56 +0100
Subject: RE: [RFC PATCH] Rework gpio cansleep (was Re: gpiolib and
 sleepinggpios)
Thread-Topic: [RFC PATCH] Rework gpio cansleep (was Re: gpiolib and
 sleepinggpios)
Thread-Index: AcsTMWtuLMm8vQ1iRTaEcMbovHf13QAJHQgg
Message-ID: <70E876B0EA86DD4BAF101844BC814DFE08E0855B96@Cloud.RL.local>
In-Reply-To: <20100624000403.GH7058@shareable.org>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier wrote:
> Ryan Mallon wrote:
>> On 06/24/2010 10:53 AM, Jamie Lokier wrote:

>>> It has an I2C driven GPIO expander, with a watchdog reset chip
>>> hanging off the expander.
>>>
>>> The watchdog is kept alive off the back end of a timer BH, which
>>> means the I2C GPIO routines are written to be safe in BH context
>>> (which
>>> isn't sleepable), but they can't be used in IRQ context because the
>>> necessary spin_lock_irqsave() would turn off interrupts for too long
>>> for other subsystems to function properly.
>>
>> Do the implementations of the get/set calls for the io expander gpios
>> sleep at all?
>
> No, because sleeping isn't allowed in BH context.  (Note that this is
> 2.4.26 code - things have changed a bit for 2.6, but the hardware is
> the same, and still needs the I2C watchdog to be driven from a BH-like
> context).

Could you use a workqueue instead to prod the watchdog?
Then the GPIOs could sleep, you could rewrite them as such, and other things could use them safely.

Disabling IRQs while you talk to an I2C peripheral sounds like a hack that will impact performance.

Although, if it does that then I think your GPIOs qualify as non-sleeping.. so "safe" to use from a can't-sleep context but probably unacceptably slow as you say.

--
Jon Povey
jon.povey@racelogic.co.uk

Racelogic is a limited company registered in England. Registered number 2743719 .
Registered Office Unit 10, Swan Business Centre, Osier Way, Buckingham, Bucks, MK18 1TB .

The information contained in this electronic mail transmission is intended by Racelogic Ltd for the use of the named individual or entity to which it is directed and may contain information that is confidential or privileged. If you have received this electronic mail transmission in error, please delete it from your system without copying or forwarding it, and notify the sender of the error by reply email so that the sender's address records can be corrected. The views expressed by the sender of this communication do not necessarily represent those of Racelogic Ltd. Please note that Racelogic reserves the right to monitor e-mail communications passing through its network


