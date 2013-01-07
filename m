Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab3AGVGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 16:06:12 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:54979 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755659Ab3AGVGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 16:06:09 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19MiNVaIyIsFQMoDgtF1q5q
Date: Mon, 7 Jan 2013 13:05:52 -0800
From: Tony Lindgren <tony@atomide.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jon Loeliger <jdl@jdl.com>, Stephen Warren <swarren@wwwdotorg.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benoit Cousson <b-cousson@ti.com>, Mitch Bradley <wmb@firmworks.com>,
        Alan Tull <atull@altera.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Joel A Fernandes <agnel.joel@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>
Subject: Re: [PATCH 1/5] capemgr: Beaglebone DT overlay based cape manager
Message-ID: <20130107210551.GL14149@atomide.com>
References: <1357584666-17374-1-git-send-email-panto@antoniou-consulting.com>
 <1357584666-17374-2-git-send-email-panto@antoniou-consulting.com>
 <20130107200945.GF14149@atomide.com>
 <379B16EC-BFAA-4C27-8321-E7133C03368D@antoniou-consulting.com>
 <20130107202306.GH14149@atomide.com>
 <FA4D880E-833E-43D9-A399-0A5C260E83F2@antoniou-consulting.com>
 <20130107203529.GI14149@atomide.com>
 <93BF5C62-ADE8-4EFC-9175-C2D7E43300E3@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93BF5C62-ADE8-4EFC-9175-C2D7E43300E3@antoniou-consulting.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pantelis Antoniou <panto@antoniou-consulting.com> [130107 12:43]:
> Hi Tony,
> 
> On Jan 7, 2013, at 10:35 PM, Tony Lindgren wrote:
> 
> > * Pantelis Antoniou <panto@antoniou-consulting.com> [130107 12:29]:
> >> On Jan 7, 2013, at 10:23 PM, Tony Lindgren wrote:
> >>> 
> >>> Well how about split it to an eeprom driver, and Linux generic
> >>> device loader parts?
> >>> 
> >> 
> >> All that's left is the eeprom driver (accessor) and calls to the 
> >> generic DT overlay constructs. 
> >> 
> >> If you caught on the previous patchset about DT overlays it should be
> >> clear.
> >> 
> >> So it is split along those lines already.
> > 
> > Hmm I was thinking something like this:
> > 
> > drivers/base/device-loader.c
> > drivers/misc/eeprom/beaglebone-cape.c
> > 
> > Then you may be able to just load the configuration for it
> > from a .dts file and maybe no hardware specific glue is even
> > needed.
> > 
> 
> At the end of the line, some kind of hardware glue is going to be needed.
> 
> I just feel that drawing from a sample size of 1 (maybe 2 if I get to throw
> in the beagleboard), it is a bit premature to think about making it overly
> general, besides the part that are obviously part of the infrastructure 
> (like the DT overlay stuff).
> 
> What I'm getting at, is that we need some user experience about this, before
> going away and creating structure out of possible misconception about the uses. 

IMHO stuff like this will be needed by many SoCs. Some examples of similar
things for omaps that have eventually become generic frameworks have been
the clock framework, USB OTG support, runtime PM, pinmux framework and
so on.

So I suggest a minimal generic API from the start as that will make things
a lot easier in the long run.

Regards,

Tony
