Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab0I1WmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 18:42:01 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:45650 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753138Ab0I1Wl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 18:41:59 -0400
X-Authenticated: #31060655
X-Provags-ID: V01U2FsdGVkX19orJtwWLRo7C1Kk7r0IW6se6mUQgkIFD/lRiBoBU
	Aq7TrddZBoDVNm
Message-ID: <4CA26F35.6060408@gmx.net>
Date: Wed, 29 Sep 2010 00:41:57 +0200
From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.23) Gecko/20090410 SUSE/1.1.18-0.1 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        sf-linux-drivers <linux-net-drivers@solarflare.com>,
        flashrom <flashrom@flashrom.org>
Subject: Re: [RFC] Online firmware upgrade in non-embedded systems
References: <1285696787.2282.45.camel@achroite.uk.solarflarecom.com>
In-Reply-To: <1285696787.2282.45.camel@achroite.uk.solarflarecom.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding flashrom@flashrom.org to CC, senders will be whitelisted after a
short delay]

On 28.09.2010 19:59, Ben Hutchings wrote:
> Network and disk controllers normally have at least some firmware in
> flash to support their use as boot devices. [...]
>
> Currently the sfc network driver is optionally combined with an MTD
> driver (CONFIG_SFC_MTD) which exposes all upgradable firmware and
> configuration partitions in flash.  This works nicely in kernels with
> MTD enabled, but since MTD is mainly used in embedded systems with
> on-board flash it is often disabled in distribution kernels and custom
> kernels alike.  This leaves users of sfc unable to upgrade firmware
> without rebuilding the kernel or booting some other distribution.  The
> lack of widespread MTD support is a regular cause of support requests.
>
> There are two main alternatives I'm aware of:
>
> - Use the ethtool ETHTOOL_SEEPROM [...]
>
> - Use the ethtool ETHTOOL_FLASHDEV command [..]
>
> Of course these are both specific to network devices; it seems deisrable
> to have a more general convention for online firmware upgrades.  MTDs
> clearly are more generally applicable, and pretty much every computer
> does have flash storage for firmware and boot configuration, so perhaps
> it should be treated as more of a standard feature?
>   

Given that the flashrom utility <http://www.flashrom.org/> (GPLv2)
supports flashing many network cards, SATA/PATA controllers, graphics
cards, and of course the main system firmware/BIOS/EFI, and it does that
from userspace without any kernel support, using flashrom for those
purposes makes sense IMHO.

flashrom works fine under Linux 2.4, 2.6 and pretty much every other OS
out there. There is a focus on x86, but MIPS, PowerPC and other
architectures are supported as well. flashrom is independent of the MTD
framework, so you don't need to boot a special kernel for a firmware
upgrade.

That said, writing a flashrom driver for your hardware is pretty easy.
You could even use existing kernel code for your device as a template
for the flashrom driver since the license is compatible.

If you have any questions, please ask.

Regards,
Carl-Daniel
