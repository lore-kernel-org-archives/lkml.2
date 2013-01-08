Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab3AHJvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 04:51:48 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:60117 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab3AHJvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 04:51:45 -0500
Date: Tue, 8 Jan 2013 10:51:29 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Pantelis Antoniou <panto@antoniou-consulting.com>
cc: Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jon Loeliger <jdl@jdl.com>, Stephen Warren <swarren@wwwdotorg.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benoit Cousson <b-cousson@ti.com>, Mitch Bradley <wmb@firmworks.com>,
        Alan Tull <atull@altera.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Joel A Fernandes <agnel.joel@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/5] capemgr: Beaglebone DT overlay based cape manager
In-Reply-To: <89A7A8FD-935E-4225-8C7B-EA1DBA0C2780@antoniou-consulting.com>
Message-ID: <Pine.LNX.4.64.1301081033440.1794@axis700.grange>
References: <1357584666-17374-1-git-send-email-panto@antoniou-consulting.com>
 <93BF5C62-ADE8-4EFC-9175-C2D7E43300E3@antoniou-consulting.com>
 <20130107210551.GL14149@atomide.com> <201301072135.05166.arnd@arndb.de>
 <89A7A8FD-935E-4225-8C7B-EA1DBA0C2780@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:stHbiDalFHiOxQrHZSloxrW6hzQaUrCkvNao/P4pAA4
 Z1UxeaMMrRkG7+/JD4/NhmA7wBfjQPGu63pK4Yb7ycR/3ec/3y
 xg/ps2K0+ECQYGLYeVM2JwXhVTEBiGQKtpufIxgmQt9sqaNmBC
 H+PZy5j9q6NLRsAX/ZnDVn/wDH9aoNkrmibc67aJK1jiP3b1S2
 K7w1amjSi/52UPWNhbB0e8AwX2u0WeDlOFS5bPfgfTygD3cppd
 cP8H9GoTcZO/v6pNr04JJEbrKpfUO0LVAogFVe0JhY0gqsLDoo
 LWPIhRVfIWYj4c/OLBKPWPlCdzy945kDOdGeoZybvNURT9wqoq
 biKinMUBpfz/d61DY5LVqFgDx6FT36Jyemg0NJaHyHXnXnrvmm
 jZXlqIQpxeMYw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding linux-media ML to cc)

Hi Pantelis

On Tue, 8 Jan 2013, Pantelis Antoniou wrote:

> Hi Arnd,
> 
> On Jan 7, 2013, at 11:35 PM, Arnd Bergmann wrote:
> 
> > (Adding Sascha Hauer, Linus Walleij, Lee Jones to Cc)
> > 
> > On Monday 07 January 2013, Tony Lindgren wrote:
> >>> 
> >>> At the end of the line, some kind of hardware glue is going to be needed.
> >>> 
> >>> I just feel that drawing from a sample size of 1 (maybe 2 if I get to throw
> >>> in the beagleboard), it is a bit premature to think about making it overly
> >>> general, besides the part that are obviously part of the infrastructure 
> >>> (like the DT overlay stuff).
> >>> 
> >>> What I'm getting at, is that we need some user experience about this, before
> >>> going away and creating structure out of possible misconception about the uses. 
> >> 
> >> IMHO stuff like this will be needed by many SoCs. Some examples of similar
> >> things for omaps that have eventually become generic frameworks have been
> >> the clock framework, USB OTG support, runtime PM, pinmux framework and
> >> so on.
> >> 
> >> So I suggest a minimal generic API from the start as that will make things
> >> a lot easier in the long run.
> > 
> > I agree. The ux500 platform already has the concept of "user interface boards",
> > which currently is not well integrated into devicetree. I believe Sascha
> > mentioned that Pengutronix had been shipping some other systems with add-on
> > boards and generating device tree binaries from source for each combination.
> > 
> > Ideally, both of the above should be able to use the same DT overlay logic
> > as BeagleBone, and I'm sure there are more of those.
> > 
> > 	Arnd
> 
> Hmm, I see. 
> 
> I will need some more information about the interface of the 'user interface boards'.
> I.e. how is the board identified, what is typically present on those boards, etc.
> 
> Can we get some input by the owner of other similar hardware? I know the FPGA
> people have similar requirements for example. There are other people that are hitting
> problems getting DT to work with their systems, like the V4L people with the order
> of initialization; see http://lwn.net/Articles/531068/. I think the V4L problem is
> cleanly solved by the overlay being contained in the V4L device node and applied just before
> the device is probed.

You probably mean these related V4L patches: 
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/58646 
that base upon of asynchronous V4L2 subdevice probing, referenced above. 
Yes, V4L DT nodes, as documented in 
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/58646/focus=58648 
contain "port" and "endpoint" nodes, that describe the configuration of 
the hardware port and link to devices, connected to it. Not sure how well 
this would work with DT overlays, because endpoint nodes on both sides of 
the video data bus contain references to the other side and I don't know 
whether and how these can be created and / or updated at run-time. 
Otherwise, yes, the approach that we're currently developing on V4L allows 
us to build video data pipelines independent of (sub)device driver probing 
order.

Thanks
Guennadi

> In the meantime it would be better to wait until we have some ack from the maintainers
> of the core subsystems about what they think.
>  
> Regards
> 
> -- Pantelis

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
