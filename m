Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab1KXTWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 14:22:12 -0500
Received: from mo2.mail-out.ovh.net ([178.32.228.2]:52543 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab1KXTWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 14:22:10 -0500
Date: Thu, 24 Nov 2011 20:22:06 +0100
From: Marc Vertes <marc.vertes@sigfox.com>
To: wim@iguana.be, HaraldWelte@viatech.com
Cc: w.sang@pengutronix.de, mad_soft@inbox.ru, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH RFC] watchdog: add a new driver for VIA chipsets
Message-ID: <4ece995e.x4p0mK5XK7QoXS86%marc.vertes@sigfox.com>
References: <4ecb84b9.48rmEWqC3D6x18iE%marc.vertes@sigfox.com>
 <20111122112212.GD2734@pengutronix.de>
 <4ecbd66c.8a87vIwdu0Z+quuZ%marc.vertes@sigfox.com>
 <20111122173029.GA14349@pengutronix.de>
 <4ecbe56d.0B7WEVDKkK1s88MJ%marc.vertes@sigfox.com>
 <4ecbf011.dZASXe6D5kH4Uxve%marc.vertes@sigfox.com>
 <20111123121051.GA18320@rainbow>
 <20111123182209.GF5315@prithivi.gnumonks.org>
 <20111123214115.GO23376@infomag.iguana.be>
In-Reply-To: <20111123214115.GO23376@infomag.iguana.be>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 11051552012463359791
X-Ovh-Remote: 92.103.90.130 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: 0
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefiedrtdelucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhgjfgggtgfgsehtjeertddtredvnecuhfhrohhmpeforghrtgcugggvrhhtvghsuceomhgrrhgtrdhvvghrthgvshesshhighhfohigrdgtohhmqeenucffohhmrghinhepne
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefhedrudehucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucculddquddttddm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wim Van Sebroeck <wim@iguana.be> wrote:

> Hi Harald,
>
> > Unfortunately it simply doesn't work.  When I originally implemented a
> > via_wdt driver some years ago, I couldn't start the watchdog no matter
> > how hard I tried.  My inquiries into VIA at that point didn't provide
> > any response either.  In fact, I even feared that nobody might ever have
> > used that watchdog hardware before ;)
> > 
> > I can ask again, but I'm not sure if it will be any different at that
> > time..
>
> Could you please ask again? It could indeed be that they lock registers.
> (It could be something similar to some of the superIO chipsets that can
> enable/disable (lock/unlock) access to registers).
>
> The BIOS can at least start the hardware, so the hardware does work :-)
>
Hey, I just discovered that enabling Plug&Play in the BIOS is the key!

It unlocks watchdog control registers and opens access to counters and
all the stuff. Sometimes lateral thinking helps :-)

So the driver will be able to normally support all features as documented
in the datasheet. I plan an update tomorrow.

Regards,
--
Marc
