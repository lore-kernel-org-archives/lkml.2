Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab1EVKDT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 06:03:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64709 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab1EVKDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 06:03:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] drivers/amba: probe via device tree
Date: Sun, 22 May 2011 12:03:03 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
        Rob Herring <robherring2@gmail.com>,
        devicetree-discuss@lists.ozlabs.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Segher Boessenkool <segher@kernel.crashing.org>
References: <1305829704-11774-1-git-send-email-robherring2@gmail.com> <a42f0c27-2811-4b68-bedf-7dfaa7bff6ff@VA3EHSMHS025.ehs.local> <BANLkTi=8vX1Cs_fzpQXZBuuDuLYLu1FGmg@mail.gmail.com>
In-Reply-To: <BANLkTi=8vX1Cs_fzpQXZBuuDuLYLu1FGmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105221203.03970.arnd@arndb.de>
X-Provags-ID: V02:K0:gH77aHz/ZTFWU+tr+nUGVahQPvbW/8Xibxkjgnfnaa8
 F5YRif99yVQZu37vsLlFIEXElwcVPFuQicMbMW0OwnTsgeIl5g
 lMiLNecL1t66x4rHDg4aE/XvaaHB1t8La63NyPFp/0So6ekgv2
 Zy5vJwRTGv1/NtF/dboXXD/Vs0guIAGeDMRr5Tl/kw+tQNYY7N
 TFkZGpRgBNcvc7brTHAnw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 May 2011 19:42:34 Grant Likely wrote:
> 1) drop amba-bus entirely and use platform_device everywhere, similar
> to what OMAP has done
> 2) strictly create amba_devices for nodes compatible with "arm,amba-device"
> 3) be intelligent about amba device creation; create an amba_device
> only for devices we know are driven with amba_driver.

Or maybe

4) Use amba_device for all devices on an amba bus (identified by
the compatible property of the bus), but mark the ones that do
not have primecell compatible registers so that the amba bus
does not try to look at them but instead takes the information
from the device tree.

Even though this might seem a bit silly when most devices are
not primecell ones, but it could be used as an incentive for
hardware designers (I can dream, right?) to provide them in future
designs. It would also make it easier to document the actual bus
hierarchy correctly.

	Arnd
