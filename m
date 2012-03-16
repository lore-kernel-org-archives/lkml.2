Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672Ab2CPDEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 23:04:04 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:4428
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753797Ab2CPDD7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 23:03:59 -0400
X-SpamScore: -14
X-BigFish: VS-14(zzc89bh1432N98dK1447Mzz1202hzz8275chz2dh2a8h668h839hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 16 Mar 2012 11:05:21 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "vinod.koul@linux.intel.com" <vinod.koul@linux.intel.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v1 1/5] ARM: imx28: add basic dt support
Message-ID: <20120316030521.GB5161@shlinux2.ap.freescale.net>
References: <1331628428-24017-1-git-send-email-b29396@freescale.com>
 <1331628428-24017-2-git-send-email-b29396@freescale.com>
 <20120313172351.97C5E3E053B@localhost>
 <20120314124512.GG1180@shlinux2.ap.freescale.net>
 <20120314141643.GP3852@pengutronix.de>
 <20120315030206.GB13022@shlinux2.ap.freescale.net>
 <20321.37353.63115.664975@ipc1.ka-ro>
 <20120315105927.GE13022@shlinux2.ap.freescale.net>
 <20120315112419.GA3852@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20120315112419.GA3852@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 07:24:19PM +0800, s.hauer@pengutronix.de wrote:
> On Thu, Mar 15, 2012 at 06:59:28PM +0800, Dong Aisheng wrote:
> > On Thu, Mar 15, 2012 at 02:53:29PM +0800, Lothar Waßmann wrote:
> > > Hi,
> > > 
> > > Dong Aisheng writes:
> > > > On Wed, Mar 14, 2012 at 10:16:43PM +0800, s.hauer@pengutronix.de wrote:
> > > > > On Wed, Mar 14, 2012 at 08:45:23PM +0800, Dong Aisheng wrote:
> > > > > > On Wed, Mar 14, 2012 at 01:23:51AM +0800, Grant Likely wrote:
> > > [...]
> > > > > > But it seems this needs pass mac address to fec driver via platforom data which is
> > > > > > not friendly to dt.
> > > > > > 
> > > > > > Another way may be changing fec driver to get the fixed part of mac address(first
> > > > > > two bytes) from device tree and read the left dynamical part from otp which i'm not
> > > > > > sure is better enough.
> > > > > > 
> > > > > > BTW, filling with zeros seems not work since it's invalid mac address.
> > > > > 
> > > > > Yes, that's the idea of using this value...
> > > > > 
> > > > But comparing to use an invalid value, why not just do not define that
> > > > local-mac-address property?
> > > > 
> > > Because a MAC address is by definition a GLOBALLY UNIQUE IDENTIFIER
> > > which is contrary to coding a "valid" default value for it somewhere!
> > > The owner of a certain MAC address range (OUI) is responsible for
> > > ensuring the uniqueness. Thus only they may assign a specific MAC
> > > address to a specific device.
> > > 
> > Yes, you're correct.
> > So i propose to read the MAC address from MX28 OTP in fec driver instead of
> > define it in device tree in my last mail.
> > http://www.spinics.net/lists/arm-kernel/msg165040.html
> > Do you have any comment on that way?
> 
> Yes, you could do that. Otherwise it's perfectly fine to pass the MAC
> address in the device tree, it's just not ok to put specific values
> into the kernel source. You could leave the values blank and let the
Yes, correct.

> bootloader fill them in. Or you could fill in valid values before you
> compile the devicetree, but be prepared for surprises once you have
> two boards in your network and use the devicetree for both.
> 

Thanks for the info.
I will submit that patch for discussion.

Regards
Dong Aisheng

