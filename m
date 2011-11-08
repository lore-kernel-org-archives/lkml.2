Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab1KHQAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 11:00:43 -0500
Received: from 4.mo5.mail-out.ovh.net ([178.33.111.247]:40675 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755158Ab1KHQAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 11:00:42 -0500
X-Greylist: delayed 12661 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Nov 2011 11:00:41 EST
Date: Tue, 8 Nov 2011 10:59:59 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Claudio Scordino <claudio@evidence.eu.com>,
        Jesper Nilsson <Jesper.Nilsson@axis.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Mikael Starvik <mikael.starvik@axis.com>,
        Darron Black <darron@griffin.net>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, alan@linux.intel.com
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH] RS485: fix inconsistencies in the meaning of some
 variables
Message-ID: <20111108095959.GB31737@game.jcrosoft.org>
References: <4E492CFF.7040905@pwrnet.de>
 <20110822211832.GA8023@kroah.com>
 <4EB3A009.10502@evidence.eu.com>
 <4EB8F6B9.6010008@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB8F6B9.6010008@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 18295592012548647788
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -275
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfedvtddrvdduucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmneculddquddttddmnehrthhsfeigucdlqdejhedm
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -275
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeftddrvddtucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmneculddquddttddmnehrthhsfeigucdlqdejhedm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:30 Tue 08 Nov     , Nicolas Ferre wrote:
> On 11/04/2011 09:19 AM, Claudio Scordino :
> > Hi Alan, Hi Greg,
> > 
> > 	it seems that the crisv10.c and the atmel_serial.c serial
> > drivers interpret the fields of the serial_rs485 structure in a different
> > way.
> > 
> > In particular, it seems that crisv10.c uses SER_RS485_RTS_AFTER_SEND and
> > SER_RS485_RTS_ON_SEND for the _logic value_ of the RTS pin;
> > atmel_serial.c, instead, uses these values to know if a _delay_ must be
> > set before and after sending.
> 
> It seems sensible, but, on the other hand, I fear that this is a big
> change in the user interface: If people are already relying on this for
> their application, this can be difficult to understand the change. Can't
> we imagine an smoother migration path?
> 
> It seems from de6f86ce5 that 16C950 may also use rs485 mode (with
> another signal that RTS BTW)...
> 
> See comments online...
> 
> > This patch makes the usage of these variables consistent across all
> > drivers and fixes the Documentation as well.
> > In particular, SER_RS485_RTS_AFTER_SEND and SER_RS485_RTS_ON_SEND will
> > be used to set the logic value of the RTS pin (as in the crisv10.c
> > driver); the delay is understood by looking only at the value of
> > delay_rts_before_send and delay_rts_after_send.
> > 
> > Best regards,
> > 
> > 	Claudio
> > 
> > 
> > Subject: RS485: fix inconsistencies in the meaning of some variables
> > From: Claudio Scordino <claudio@evidence.eu.com>
> > 
> > The crisv10.c and the atmel_serial.c serial drivers interpret the fields
> > of the serial_rs485 structure in a different way.
> > In particular, crisv10.c uses SER_RS485_RTS_AFTER_SEND and 
> > SER_RS485_RTS_ON_SEND for the voltage of the RTS pin; atmel_serial.c, instead,
> > uses these values to know if a delay must be set before and after sending.
> > This patch makes the usage of these variables consistent across all drivers and
> > fixes the Documentation as well.
> >>From now on, SER_RS485_RTS_AFTER_SEND and SER_RS485_RTS_ON_SEND will be used to
> > set the voltage of the RTS pin (as in the crisv10.c driver); the delay will be
> > understood by looking only at the value of delay_rts_before_send and 
> > delay_rts_after_send.
> 
> Ok, but don't you think that the flags names are not so much
> self-explanatory for this new meaning?
> 
> What about:
> SER_RS485_RTS_LEVEL_DURING_SEND
> SER_RS485_RTS_VALUE_DURING_SEND (maybe too vague?)
> SER_RS485_RTS_LOGICAL_VALUE_DURING_SEND (maybe too long?)
> 
> Moreover, can't we just use one property for this? I mean, if RTS
> logical value is high during the sending of data, can it mean that RTS
> will be low before and after? And the other way around: if the signal is
> low during data send, will it be high before and after?
> 
> Here again, changing the user interface is not a good idea, so I fear
> that it can be a show stopper.
agreed with nicolas

Best Regards,
J.
