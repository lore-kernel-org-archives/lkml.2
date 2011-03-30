Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab1C3Rk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 13:40:27 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48751 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab1C3Rk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 13:40:26 -0400
Date: Wed, 30 Mar 2011 18:40:10 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Arend van Spriel <arend@broadcom.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, gregkh@suse.de,
        linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/1] new module for amba axi on-chip interconnect
Message-ID: <20110330174010.GA2939@n2100.arm.linux.org.uk>
References: <1301391619-4499-1-git-send-email-arend@broadcom.com> <20110329181947.GA18134@flint.arm.linux.org.uk> <201103301509.04899.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103301509.04899.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 03:09:04PM +0200, Arnd Bergmann wrote:
> I believe the one thing we really want from this driver is the bus
> scan code, which is not present in the amba bus implementation,
> as far as I can tell. Today, the amba bus does very little beyond
> what the platform bus does, in particular you still need to
> register every single device from board specific code.
> 
> When the proposed axi_scan() function gets turned into an
> amba_bus_register() function, a board file can call that to
> add all devices on the bus without listing them individually
> and calling amba_device_register() for each one.
> 
> Basically everything else is already there in the amba bus,
> no need to do it again.

The reason we don't do automatic scanning (which we could on the various
ARM platforms) is because of the platform data necessary to make some of
the primecell drivers work.

Unfortunately, these buses are not as simple as PCI, where a device
typically sits on its own card and is totally self-contained.  With
primecell stuff, there's normally some interdependencies between the
various primecells.

That doesn't stop there being an automatic enumeration layer, but such
a layer would need some way of attaching platform specific data to
specific amba devices.
