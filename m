Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab0I2MfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:35:06 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:45515 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab0I2MfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:35:05 -0400
Subject: Re: [RFC] Online firmware upgrade in non-embedded systems
From: Ben Hutchings <bhutchings@solarflare.com>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Cc: netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        sf-linux-drivers <linux-net-drivers@solarflare.com>,
        flashrom <flashrom@flashrom.org>
In-Reply-To: <4CA26F35.6060408@gmx.net>
References: <1285696787.2282.45.camel@achroite.uk.solarflarecom.com>
	 <4CA26F35.6060408@gmx.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Wed, 29 Sep 2010 13:35:00 +0100
Message-ID: <1285763700.2283.6.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Sep 2010 12:35:04.0085 (UTC) FILETIME=[BDB70450:01CB5FD2]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17672.005
X-TM-AS-Result: No--26.032900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-29 at 00:41 +0200, Carl-Daniel Hailfinger wrote:
> [adding flashrom@flashrom.org to CC, senders will be whitelisted after a
> short delay]
> 
> On 28.09.2010 19:59, Ben Hutchings wrote:
> > Network and disk controllers normally have at least some firmware in
> > flash to support their use as boot devices. [...]
> >
> > Currently the sfc network driver is optionally combined with an MTD
> > driver (CONFIG_SFC_MTD) which exposes all upgradable firmware and
> > configuration partitions in flash.  This works nicely in kernels with
> > MTD enabled, but since MTD is mainly used in embedded systems with
> > on-board flash it is often disabled in distribution kernels and custom
> > kernels alike.  This leaves users of sfc unable to upgrade firmware
> > without rebuilding the kernel or booting some other distribution.  The
> > lack of widespread MTD support is a regular cause of support requests.
> >
> > There are two main alternatives I'm aware of:
> >
> > - Use the ethtool ETHTOOL_SEEPROM [...]
> >
> > - Use the ethtool ETHTOOL_FLASHDEV command [..]
> >
> > Of course these are both specific to network devices; it seems deisrable
> > to have a more general convention for online firmware upgrades.  MTDs
> > clearly are more generally applicable, and pretty much every computer
> > does have flash storage for firmware and boot configuration, so perhaps
> > it should be treated as more of a standard feature?
> >   
> 
> Given that the flashrom utility <http://www.flashrom.org/> (GPLv2)
> supports flashing many network cards, SATA/PATA controllers, graphics
> cards, and of course the main system firmware/BIOS/EFI, and it does that
> from userspace without any kernel support,
[...]

I'm looking for a clean solution, not a hack.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

