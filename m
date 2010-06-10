Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711Ab0FJNPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 09:15:18 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:42838 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608Ab0FJNPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 09:15:17 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, Eric Miao <eric.y.miao@gmail.com>,
       dbaryshkov@gmail.com, Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
       kernel list <linux-kernel@vger.kernel.org>, utx@penguin.cz,
       lenz@cs.wisc.edu, rpurdie@rpsys.net, pave@ucw.cz, thommycheck@gmail.com,
       zaurus-devel@www.linuxtogo.org, omegamoon@gmail.com
Subject: Re: usb gadget on zaurus and kexec
References: <20100519154618.GA26381@atrey.karlin.mff.cuni.cz>
	<AANLkTim49akRJK0BN_Qk1wL6e5mrdjZioDjGNWlrjUVQ@mail.gmail.com>
	<AANLkTilCvgvf9Ch55f878nTNTue8tHYmcrLEywsjnylY@mail.gmail.com>
	<201006100900.23981.marek.vasut@gmail.com>
X-URL: http://belgarath.falguerolles.org/
Date: Thu, 10 Jun 2010 15:14:52 +0200
In-Reply-To: <201006100900.23981.marek.vasut@gmail.com> (Marek Vasut's message
	of "Thu, 10 Jun 2010 09:00:23 +0200")
Message-ID: <87wru7xc4z.fsf@free.fr>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marek Vasut <marek.vasut@gmail.com> writes:

>> > Dumping out the registers of the two situations and doing a comparison
>> > then might be a quick way.
>> 
>> Any debugging update on this?
>
> Yeah, there's a workaround. Cyril's working on a proper fix, but that might take 
> some time. Simply -- UP2OCR is misconfigured.

That's quite interesting. In the pxa27x_udc gadget driver, I seem to have a
regression on the resume from suspend to RAM path. My USB UDC is not enumerated
anymore.

The might be a correlation, as UP2OCR is lost in the suspend process. I'm very
interested by your analysis of the issue you have on kexec, as that might ease
my work :)

Besides, it's been some time I've been thinking that the pxa deserves a proper
encapsulation of the USB internal routing paths (ie. a proper way to switch from
usb host handled by ohci-pxa27x to an usb client handled by pxa2x_udc), to
reflect the setup of the Pad Unit (see TRM chapter 12.4 : tables 12.2, 12.15,
12.17, 12.18 and 12.19).

Whatever you find on the USB Port2 configuration register would help me design
the Pad block.

Cheers.

--
Robert
