Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927Ab1CCMUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 07:20:40 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:28369 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab1CCMUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 07:20:39 -0500
Date: Thu, 3 Mar 2011 13:20:25 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Dirk Eibach <eibach@gdsys.de>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, rdunlap@xenotime.net,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] hwmon: (ads1015) Add devicetree documentation
Message-ID: <20110303132025.51e0d92e@endymion.delvare>
In-Reply-To: <20110303115151.GF3649@pengutronix.de>
References: <1299143805-13133-1-git-send-email-eibach@gdsys.de>
	<20110303115151.GF3649@pengutronix.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

On Thu, 3 Mar 2011 12:51:51 +0100, Wolfram Sang wrote:
> On Thu, Mar 03, 2011 at 10:16:45AM +0100, Dirk Eibach wrote:
> > Signed-off-by: Dirk Eibach <eibach@gdsys.de>
> > ---
> >  Documentation/devicetree/bindings/i2c/ads1015.txt |   15 +++++++++++++++
> >  1 files changed, 15 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/i2c/ads1015.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/i2c/ads1015.txt b/Documentation/devicetree/bindings/i2c/ads1015.txt
> > new file mode 100644
> > index 0000000..3a7d67a
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/i2c/ads1015.txt
> > @@ -0,0 +1,15 @@
> > +ADS1015 (I2C)
> > +
> > +Optional properties:
> > +
> > + - exported-channels : exported_channels is a bitmask that specifies which
> > +		       inputs should be exported to sysfs.
> 
> Hmm, device tree bindings should be OS-neutral, sysfs is not.

Why do we document this in the Linux kernel tree then?

> Maybe
> "active-channels" would be better; then the OS could decide what to do
> with the active channels. Then again, what is the drawback of exporting
> all channels?

Performance and user-friendliness. libsensors-based applications will
read all available attributes by default, and each reading takes time.
Letting the platform declare how the inputs are used allows for a sane
output for "sensors" and other similar tools out of the box, without
the user having to tinker with ignore statements in configuration files
to discard the nonsensical values.

> Is there another hwmon-driver doing so (couldn't find one)?

If "doing so" means "letting the user define how the ADC inputs are
used", then yes, the pcf8591 driver does something similar, except that
it uses a module parameter for the setting, for historical reasons.
Platform-provided, per-device data is better in my opinion.

-- 
Jean Delvare
