Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752Ab1E0JDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 05:03:11 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:37749 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab1E0JDH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 05:03:07 -0400
Date: Fri, 27 May 2011 11:01:30 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Peter Tyser <ptyser@xes-inc.com>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe =?ISO-8859-1?B?S2xlaW5lLUv2bmln?= 
	<u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Syed S Azam <Syed.Azam@hp.com>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: Re: [PATCH v6] gpio: Add support for Intel ICHx/3100/Series[56]
 GPIO
Message-ID: <20110527110130.4b3448f2@endymion.delvare>
In-Reply-To: <20110527064238.GA31271@ponder.secretlab.ca>
References: <1299022100-14564-4-git-send-email-ptyser@xes-inc.com>
	<1303317354-18188-1-git-send-email-ptyser@xes-inc.com>
	<20110527064238.GA31271@ponder.secretlab.ca>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Fri, 27 May 2011 00:42:38 -0600, Grant Likely wrote:
> On Wed, Apr 20, 2011 at 11:35:54AM -0500, Peter Tyser wrote:
> > This driver works on many Intel chipsets, including the ICH6, ICH7,
> > ICH8, ICH9, ICH10, 3100, Series 5/3400 (Ibex Peak), Series 6/C200
> > (Cougar Point), and NM10 (Tiger Point).
> > 
> > Additional Intel chipsets should be easily supported if needed, eg the
> > ICH1-5, EP80579, etc.
> > 
> > Tested on a QM57 (Ibex Peak), 3100 (Whitmore Lake) , and
> > NM10 (Tiger Point).
> > 
> > Cc: Alek Du <alek.du@intel.com>
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > Cc: Eric Miao <eric.y.miao@gmail.com>
> > Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > Cc: Joe Perches <joe@perches.com>
> > Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Cc: Syed S Azam <Syed.Azam@hp.com>
> > Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
> > Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
> > Tested-by: Vincent Palatin <vpalatin@chromium.org>
> 
> Hmmm, I merged a patch from Jean Delvare adding support for Intel
> 82801 gpio pins[1].  Does this driver support the same hardware?  I see
> the same PCI ids.
> 
> [1] https://lkml.org/lkml/2011/4/19/170

There is indeed a common range in the supported devices: ICH6 to ICH10.
My driver also supports older ICH chips (ICH to ICH5), while Peter's
support newer devices my driver does not (basically everything after
the ICH10).

Another key difference is that my driver is a simple PCI driver, while
Peter's is a platform driver. It makes some sense to have a platform
driver because the PCI device is a multifunction device so other
drivers may want to bind to it. However, I suspect that the other
functions (ACPI?) will never need a driver (not in the Linux device
driver binding model sense of the term at least) which is why I did not
bother. Peter, what was you reason to go for a platform driver? If you
really want to it go that route, you'll have to follow the standard MFD
model (see drivers/mfd/lpc_sch.c for an example.)

The only device I really care to see supported at the moment is the
ICH10, and it is supported by both drivers, so I don't care too much
which driver is picked.

-- 
Jean Delvare
