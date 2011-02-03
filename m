Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab1BCPCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 10:02:35 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60183 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755571Ab1BCPCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:02:34 -0500
Date: Thu, 3 Feb 2011 15:04:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Russ Gorby <russ.gorby@intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        "open list:SPI SUBSYSTEM" <spi-devel-general@lists.sourceforge.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] spi: intel_mid_ssp_spi: new SPI driver for intel
 Medfield platform
Message-ID: <20110203150432.40cd74c4@lxorguk.ukuu.org.uk>
In-Reply-To: <20110203132800.GA17825@sirena.org.uk>
References: <1296680512-2758-2-git-send-email-russ.gorby@intel.com>
	<20110202224054.7916e7af@lxorguk.ukuu.org.uk>
	<20110203132800.GA17825@sirena.org.uk>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Feb 2011 13:28:00 +0000
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Wed, Feb 02, 2011 at 10:40:54PM +0000, Alan Cox wrote:
> 
> > And this is the unified one that handles all the devices, but I gather
> > may need some fixing/test work on Medfield.
> 
> I've got the same question here as I had with Russ' patch: it looks like
> there's some overlap with the SSP ports used for audio (it's just a
> generic programmable serial port so even if it's not normally used for
> audio that's a possiblity), how is that handled?

The SSP has PCI configuration indicating how it is being assigned, which
is in vendor capability byte 6. The low 3 bits indicte the mode, where
mode 1 is an SPI master/slave, and in that case bit 6 is set for a slave.

The SSP/SPI driver will only grab ports that have been assigned to that
purpose as part of the system design.

I'm just putting the other bits from the generic driver back into the
more featured/tested specific driver that Russ posted.

Alan
