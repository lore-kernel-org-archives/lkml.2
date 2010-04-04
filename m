Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab0DDKfd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 06:35:33 -0400
Received: from isilmar.linta.de ([213.133.102.198]:51210 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752734Ab0DDKf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 06:35:28 -0400
Date: Sun, 4 Apr 2010 12:35:15 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, power@bughost.org
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: A few questions and issues with dynticks, NOHZ and powertop
Message-ID: <20100404103515.GA4962@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>, power@bughost.org,
	linux-kernel@vger.kernel.org,
	Arjan van de Ven <arjan@linux.intel.com>
References: <20100403223328.GA4507@comet.dominikbrodowski.net>
 <20100403235326.GA23445@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100403235326.GA23445@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Sat, Apr 03, 2010 at 04:53:26PM -0700, Dmitry Torokhov wrote:
> On Sun, Apr 04, 2010 at 12:33:28AM +0200, Dominik Brodowski wrote:
> > 
> > 4) SynPS/2 touchpad: 
> > Why does moving the touchpad lead to sooo many IRQs? I can't look as fast
> > as the mouse pointer seems to get new data:
> >   62,5% (473,1)       <interrupt> : PS/2 keyboard/mouse/touchpad 
> > 
> 
> 80 pps @ 6 bytes/packet = 480 interrupts/sec.
> 
> You can try using psmouse.rate=40 to limit it to 40 pps which should
> bring it to the rate of standard PS/2 mouse at the expense of
> sensitivity...

Excellent. Maybe this could be added to the Tips&Tricks section at the
Powertop website?

I guess obtaining all 6 bytes at once is not really possible? It
seems a new byte only appears ~1.75 ms after the last one, at least on my
notebook, so waiting for this is not an option...

Best,
	Dominik


PS: Dmitry, got something small for you in return:


[PATCH] i8042: spelling fix

Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>

diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 9302ba0..f61233e 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -38,7 +38,7 @@ MODULE_PARM_DESC(noaux, "Do not probe or use AUX (mouse) port.");
 
 static bool i8042_nomux;
 module_param_named(nomux, i8042_nomux, bool, 0);
-MODULE_PARM_DESC(nomux, "Do not check whether an active multiplexing conrtoller is present.");
+MODULE_PARM_DESC(nomux, "Do not check whether an active multiplexing controller is present.");
 
 static bool i8042_unlock;
 module_param_named(unlock, i8042_unlock, bool, 0);
