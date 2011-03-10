Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab1CJNh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 08:37:27 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33256 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab1CJNhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 08:37:25 -0500
Date: Thu, 10 Mar 2011 14:37:15 +0100
From: "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
To: David Jander <david.jander@protonic.nl>
Cc: Nguyen Dinh-R00091 <R00091@freescale.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Zhang Lily-R58066 <R58066@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vaidyanathan Ranjani-RA5478 <RA5478@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>
Subject: Re: [PATCHv2 1/2] ARM: mx51: Implement code to allow mx51 to enter
 WFI
Message-ID: <20110310133715.GC29521@pengutronix.de>
References: <1299281399-32304-1-git-send-email-Dinh.Nguyen@freescale.com>
 <56132A77AB93C141BF06E6B96CA6CFEA19124C@039-SN1MPN1-004.039d.mgd.msft.net>
 <87oc5puwg3.fsf@lebrac.rtp-net.org>
 <56132A77AB93C141BF06E6B96CA6CFEA193F14@039-SN1MPN1-004.039d.mgd.msft.net>
 <87fwqyvrzf.fsf@lebrac.rtp-net.org>
 <56132A77AB93C141BF06E6B96CA6CFEA1940F8@039-SN1MPN1-004.039d.mgd.msft.net>
 <20110307180700.GQ29521@pengutronix.de>
 <20110308124023.5a952d13@archvile>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110308124023.5a952d13@archvile>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:32:06 up 22 days,  1:29, 88 users,  load average: 0.13, 0.44,
 0.58
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, Mar 08, 2011 at 12:40:23PM +0100, David Jander wrote:
> 
> Hi Sascha,
> 
> On Mon, 7 Mar 2011 19:07:00 +0100
> "s.hauer@pengutronix.de" <s.hauer@pengutronix.de> wrote:
> >[...]
> > > The current imx for-next tree is not booting on my Babbage board. Is
> > > it okay for you with your HW. I'll have to debug the booting part
> > > first.
> > 
> > Probably because other than kconfig states i.MX51 and i.MX53 cannot be
> > compiled in one kernel. the for-next branch boots fine on my babbage.
> 
> Would you mind explaining (or pointing to an explanation) as to why this is
> not supposed to work? Given the high level of compatibility between MX51 and
> MX53, I'd say there must be a very good reason not to enable a single binary
> kernel for both. Or is this just temporary brokenness?

i.MX51 and i.MX53 have different phys_offsets. Look at
arch/arm/mach-mx5/Makefile.boot:

   zreladdr-$(CONFIG_ARCH_MX50) := 0x70008000
params_phys-$(CONFIG_ARCH_MX50) := 0x70000100
initrd_phys-$(CONFIG_ARCH_MX50) := 0x70800000
   zreladdr-$(CONFIG_ARCH_MX51) := 0x90008000
params_phys-$(CONFIG_ARCH_MX51) := 0x90000100
initrd_phys-$(CONFIG_ARCH_MX51) := 0x90800000
   zreladdr-$(CONFIG_ARCH_MX53) := 0x70008000
params_phys-$(CONFIG_ARCH_MX53) := 0x70000100
initrd_phys-$(CONFIG_ARCH_MX53) := 0x70800000

Compiling a kernel for i.MX50 and i.MX53 will work, but compiling a
kernel for i.MX51 and i.MX53 will and up with a kernel assuming SDRAM
at 0x70000000 which will fail on a i.MX51. We need
phys_to_virt/virt_to_phys runtime patching to get this right. This
will be merged in the next merge window.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
