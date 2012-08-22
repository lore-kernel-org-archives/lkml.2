Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab2HVVco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 17:32:44 -0400
Received: from mta06.xtra.co.nz ([210.54.141.249]:39270 "EHLO mta03.xtra.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752765Ab2HVVcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 17:32:42 -0400
Message-ID: <1345671155.2090.8.camel@gitbox>
Subject: Re: [PATCHv3 7/9] arm: vt8500: doc: Add device tree bindings for
 arch-vt8500 devices
From: Tony Prisk <linux@prisktech.co.nz>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>, linux-fbdev@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-usb@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroup.com,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, linux-serial@vger.kernel.org,
        rtc-linux@googlegroups.com, Stephen Warren <swarren@nvidia.com>,
        Mike Turquette <mturquette@ti.com>,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>
Date: Thu, 23 Aug 2012 09:32:35 +1200
In-Reply-To: <50354A09.7070507@wwwdotorg.org>
References: <1345582058-2291-1-git-send-email-linux@prisktech.co.nz>
	 <1345582058-2291-8-git-send-email-linux@prisktech.co.nz>
	 <50354A09.7070507@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-22 at 15:07 -0600, Stephen Warren wrote:
> On 08/21/2012 02:47 PM, Tony Prisk wrote:
> > Bindings for gpio, interrupt controller, power management controller,
> > timer, realtime clock, serial uart, ehci and uhci controllers and
> > framebuffer controllers used on the arch-vt8500 platform.
> > 
> > Framebuffer binding also specifies a 'display' node which is required
> > for determining the lcd panel data.
> 
> > diff --git a/Documentation/devicetree/bindings/gpio/gpio_vt8500.txt b/Documentation/devicetree/bindings/gpio/gpio_vt8500.txt
> 
> > +- #gpio-cells : should be <3>.
> > +	1) bank
> > +	2) pin number
> > +	3) flags
> 
> Should this enumerate what legal values are for flags, or point at a
> standard document that does?

There currently are no supported flags - guess this was an oversight.
I'll take a look if there are any that we might require in the future
and implement them otherwise I'll drop the flags reference.

> 
> > diff --git a/Documentation/devicetree/bindings/tty/serial/via,vt8500-uart.txt b/Documentation/devicetree/bindings/tty/serial/via,vt8500-uart.txt
> 
> > +	uart@d8210000 {
> > +		compatible = "via,vt8500-uart";
> > +		reg = <0xd8210000 0x1040>;
> > +		interrupts = <47>;
> > +	};
> 
> How does the UART know what frequency its clock input is, in order to
> calculate dividers? Should there be a clocks property to link to the
> input clock, so the rate can be queried? If so, a reference to the
> common clock binding, plus a specification of which clocks must be
> listed in the clock property should be included here.
> 

I didn't revisit the code that had already been posted in v1/v2 when I
added the common clock code and there was no clock handling code at that
point. The uart's are all clocked via a clkgen that outputs 24Mhz and
this was hardcoded in the driver.
I will correct this and add the appropriate device tree entries and
documentation.

> > diff --git a/Documentation/devicetree/bindings/video/via,vt8500-fb.txt b/Documentation/devicetree/bindings/video/via,vt8500-fb.txt
> 
> > +VIA VT8500 Display
> > +-----------------------------------------------------
> > +Required properties:
> > +- xres : lcd panel horizontal resolution
> > +- yres : lcd panel vertical resolution
> > +- left-margin,
> > +- right-margin,
> > +- hsync-len: lcd panel horizontal timings in pixels
> > +- upper-margin,
> > +- lower-margin,
> > +- vsync-len: lcd panel verticals timings in pixels
> > +- bpp: lcd panel bit-depth.
> > +	<16> for RGB565, <32> for RGB888
> 
> Shouldn't this reference Sascha Hauer's binding document (although I
> suppose it isn't checked in yet), and just document the additions? I
> wonder if this binding should be written assuming Sascha's binding doc
> will be checked in?

I haven't seen Sascha's binding yet - I'm not even sure its been agreed
upon but it does seem to be the most likely candidate so far. Hopefully
it will get accepted in this window, and I will have time to do exactly
as you commented, which was the plan from the start. This binding was
based on the most current one I had seen suggested at the time.


Given the additional comments for this patch set, and the required
changes I'll hold off posting v4 until everything is tidied up.

Regards

Tony Prisk

