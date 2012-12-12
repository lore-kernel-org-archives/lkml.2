Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab2LLMTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 07:19:42 -0500
Received: from 2.mo3.mail-out.ovh.net ([46.105.75.36]:55808 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751884Ab2LLMTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 07:19:41 -0500
Date: Wed, 12 Dec 2012 12:58:28 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mitch Bradley <wmb@firmworks.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH] drivers/pinctrl: grab default handles from device core
Message-ID: <20121212115828.GJ4398@game.jcrosoft.org>
References: <1355233246-16694-1-git-send-email-linus.walleij@stericsson.com>
 <20121211181336.GD25714@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121211181336.GD25714@kroah.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 8199647547738532726
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehiedrtdejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehjedrtdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:13 Tue 11 Dec     , Greg Kroah-Hartman wrote:
> On Tue, Dec 11, 2012 at 02:40:46PM +0100, Linus Walleij wrote:
> > diff --git a/include/linux/device.h b/include/linux/device.h
> > index 86ef6ab..dc399ab 100644
> > --- a/include/linux/device.h
> > +++ b/include/linux/device.h
> > @@ -21,6 +21,7 @@
> >  #include <linux/compiler.h>
> >  #include <linux/types.h>
> >  #include <linux/mutex.h>
> > +#include <linux/pinctrl/devinfo.h>
> >  #include <linux/pm.h>
> >  #include <linux/atomic.h>
> >  #include <linux/ratelimit.h>
> > @@ -605,6 +606,8 @@ struct device_dma_parameters {
> >   * @pm_domain:	Provide callbacks that are executed during system suspend,
> >   * 		hibernation, system resume and during runtime PM transitions
> >   * 		along with subsystem-level and driver-level callbacks.
> > + * @pins:	For device pin management.
> > + *		See Documentation/pinctrl.txt for details.
> >   * @numa_node:	NUMA node this device is close to.
> >   * @dma_mask:	Dma mask (if dma'ble device).
> >   * @coherent_dma_mask: Like dma_mask, but for alloc_coherent mapping as not all
> > @@ -656,6 +659,10 @@ struct device {
> >  	struct dev_pm_info	power;
> >  	struct dev_pm_domain	*pm_domain;
> >  
> > +#ifdef CONFIG_PINCTRL
> > +	struct dev_pin_info	pins;
> > +#endif
> 
> Can't you just make this a * to the structure, saving a bit of space for
> those that don't use this structure?  Ok, it's only saving one pointer,
> so it's really not a big deal to me if you don't want to do this, just
> asking...
> 
> Also, this will have to wait until after 3.8-rc1 before I can consider
> merging it, I'm a bit busy for the next two weeks at the least...
can do do not put ifdef in the struct as if will force us to put ifdef in the
c code too instead of just use a inline function

Best Regards,
J.
> 
> thanks,
> 
> greg k-h
