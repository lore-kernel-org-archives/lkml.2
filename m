Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab2D3Mry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 08:47:54 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34602 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753448Ab2D3Mrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 08:47:52 -0400
X-Sasl-enc: //hRK86gmGUL/vLXrO0vN+TH3nqu0isvedfV3oi4mC0E 1335790071
Message-ID: <4F9E89E6.7070508@ladisch.de>
Date: Mon, 30 Apr 2012 14:47:34 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
CC: Josh Boyer <jwboyer@gmail.com>, Borislav Petkov <borislav.petkov@amd.com>,
        andymatei@gmail.com, "Huang, Shane" <Shane.Huang@amd.com>,
        Borislav Petkov <bp@amd64.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Unhandled IRQs on AMD E-450
References: <fa.CZQqvHf3CBfYWzhSDPNOWxTTD9w@ifi.uio.no>	<fa.Vmg5vDod2/oKvwyy9BcalhoT+Lo@ifi.uio.no>	<14969994.2790.1335342903511.JavaMail.geo-discussion-forums@vbbfr18>	<4F97BA60.4080505@ladisch.de>	<20120427082203.GB9233@aftab.osrc.amd.com>	<CAPRPZsCHAOvemogn7mWnWfykhANeEx5K=OG9Xt+veDjEWOiDYA@mail.gmail.com>	<CA+5PVA6e-JaS809t9=4=SoxX4cFEYfxxb9-KAXk68ENGg6Kw8w@mail.gmail.com>	<CAPRPZsDDEYUf2a+=ZbwvFw+qJku0UvMLf0+eNDvw+FbinCbysA@mail.gmail.com>	<CA+5PVA4NJ4fB-qEVB45sz48E7kCdwZ+O5D9jvk16z4hrXSgCwQ@mail.gmail.com>	<CAPRPZsB=axM88+fGkghbh3qxDv=vRQtfrKqT0e59EZPrrS0V+A@mail.gmail.com>	<4F9E61FC.8070409@ladisch.de> <CAPRPZsBV-qJswWDfwMYjidEDsRzR-r5TG0or1--k599=Cju+tw@mail.gmail.com>
In-Reply-To: <CAPRPZsBV-qJswWDfwMYjidEDsRzR-r5TG0or1--k599=Cju+tw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeroen Van den Keybus wrote:
>> Why 5?  This threshold is likely to be too low; fast consecutive interrupts
>> can easily happen more often with a very busy device, while an actual stuck
>> interrupt will call the handler in an endless loop and very quickly result
>> in many thousands of calls.
>
> Well, 5 works fine on any machine I have tested so far. I'd like to
> keep this number as low as possible in case a genuine stuck interrupt
> is encountered. Computers are powerful, but I'm reluctant to spill
> cycles and power.

A stuck interrupt is the consequence of a bug, there is no need to
compromise just to optimize for this situation (especially as even with
your broken hardware and the patch, stuck interrupts happen no more than
once per second).

> Also, on an unshared interrupt line, unhandled IRQs should never
> happen in succession.

Indeed.  But this is because pending interrupts are not queued but simply
noted with a boolean.

> ... broken hardware, i.e. hardware emitting MSIs without getting
> acknowledgement). Am I right ?

Level-triggered interrupts would need acknowledgements to deactivate
the interrupt line, but MSIs do not.  Hardware that is designed to
take advantage of this indeed works this way; this avoids the need for
any MMIO accesses in the interrupt handler.


Regards,
Clemens
