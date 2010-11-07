Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab0KGTAR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 14:00:17 -0500
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:53610 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab0KGTAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 14:00:14 -0500
Date: Sun, 7 Nov 2010 20:00:09 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Sean Young <sean@mess.org>, linux-kernel@vger.kernel.org,
        jesse.barnes@intel.com
Subject: Re: [PATCH] Fix Winbond CIR driver initialisation
Message-ID: <20101107190009.GA28224@hardeman.nu>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Sean Young <sean@mess.org>, linux-kernel@vger.kernel.org,
	jesse.barnes@intel.com
References: <20101107131825.GA40383@atlantis.8hz.com>
 <20101107154648.4bcdfb9f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101107154648.4bcdfb9f@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 03:46:48PM +0000, Alan Cox wrote:
> > A workaround is to boot with argument 8250.nr_uarts=1. This is not really 
> > desirable, so this patch makes ttyS1 go away.
> 
> setserial can also be used for this surely ?

That's about as user-unfriendly as the boot option.

> > +		dev_info(device, "Unregistering phony serial port ttyS1\n");
> > +		serial8250_unregister_port(1);
> > +		ok = request_region(data->sbase, SP_IOMEM_LEN, DRVNAME);
> 
> That's a hack that is only going to work on specific systems where it is
> mapped the way you expect and doing stuff behind the back of the serial
> driver.
> 
> I'm not averse to a better solution but it needs to be general and
> maintainable. Is there a way to identify the presence of the windbond CIR
> device as opposed to an 8250 ?

Not sure which kind of identification you're looking for but would a PNP
id be sufficient?

-- 
David Härdeman
