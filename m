Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab1C3NJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 09:09:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58877 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab1C3NJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 09:09:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH 0/1] new module for amba axi on-chip interconnect
Date: Wed, 30 Mar 2011 15:09:04 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Arend van Spriel <arend@broadcom.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, gregkh@suse.de,
        linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
        linux-arm-kernel@lists.infradead.org
References: <1301391619-4499-1-git-send-email-arend@broadcom.com> <20110329181947.GA18134@flint.arm.linux.org.uk>
In-Reply-To: <20110329181947.GA18134@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103301509.04899.arnd@arndb.de>
X-Provags-ID: V02:K0:17zpePePx/M4jAhjc37JmX0M7njQaNHOXuB/C4THJeE
 QTGA9nmCSM4iPLepMb55nYD/N9jJ3MNBtMpmbGv6z3pZuzIaoi
 C7+d4FDhlwk+rNWR10HQVkuarc/frorp5l0qjlD7RpcT0Sne+j
 bS91gVeAHHUljR+Mfd8GaiZ3B1DHJES3szkrBGFasatWAX0iZj
 ILodAZCjH6/MluDjPjDLQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 March 2011, Russell King wrote:
> On Tue, Mar 29, 2011 at 11:40:18AM +0200, Arend van Spriel wrote:
> > GUIDANCE NEEDED:
> > This patch puts the module at proposed location. Please provide your
> > guidance if there is a better location within the linux tree for this
> > module.
> > 
> > This module has been isolated from the brcm80211 driver currently
> > located in staging and provided to other drivers for chipsets using
> > the AMBA AXI on-chip interconnect with ARM Device Management Plugin
> > (DMP) silicon IP, which provides system discovery (chip being the
> > system) and basic core function (disable, reset, etc.).
> 
> What does this do which the 'amba' bus support doesn't?

I believe the one thing we really want from this driver is the bus
scan code, which is not present in the amba bus implementation,
as far as I can tell. Today, the amba bus does very little beyond
what the platform bus does, in particular you still need to
register every single device from board specific code.

When the proposed axi_scan() function gets turned into an
amba_bus_register() function, a board file can call that to
add all devices on the bus without listing them individually
and calling amba_device_register() for each one.

Basically everything else is already there in the amba bus,
no need to do it again.

	Arnd
