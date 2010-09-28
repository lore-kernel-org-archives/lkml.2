Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab0I1QHD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 12:07:03 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:47190 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754535Ab0I1QHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 12:07:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Ga3hoXpWq4kRVKQM29hDHrSlPUtmdHzQFxz378UFOVsBbngDcUNOmaaCVCdJc5x0wB0+bOkmFfyj95vf8aEqFO7OWzPgl9ZtnKckMGj1KUutLHDYQI7PKFUBddqubia/;
Date: Tue, 28 Sep 2010 09:06:55 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Jimmie Mayfield <mayfield@sackheads.org>, linux-kernel@vger.kernel.org
Subject: Re: Trying to reset a PCIe device and scratching my head...
Message-ID: <20100928090655.158d1675@jbarnes-desktop>
In-Reply-To: <4CA1990E.9080206@ladisch.de>
References: <20100928020548.GA90230@sackheads.org>
	<4CA1990E.9080206@ladisch.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Sep 2010 09:28:14 +0200
Clemens Ladisch <clemens@ladisch.de> wrote:

> Jimmie Mayfield wrote:
> > Having the PCIe interface implemented inside FPGA 'A' makes upgrading
> > that particular FPGA rather troublesome.  In a perfect world, one would
> > be able to upgrade the FPGA without having to reboot the machine.  The
> > hardware guys have designed the card to reload that FPGA image upon a
> > slot reset...either fundamental or hot.
> > 
> > So I'd like to be able to send either a fundamental or hot reset to the
> > device but so far I've had no success.
> 
> The PCIe AER driver (drivers/pci/pcie/aer/) sends a hot reset when
> it has received a fatal error.  As far as I can tell, it just sets the
> PCI_BRIDGE_CTL_BUS_RESET bit of the upstream bridge; everything else
> is just infrastructure to handle error reporting and to notify the
> device driver about the reset.

Right, if your system supports this, it may be the easiest way to go.
But devices often have proprietary ways of resetting themselves too;
maybe you could change your device to reset if a specific bit in config
or MMIO space was flipped.  You'd likely need some sort of delay before
accessing the device again, but it should be bounded and fairly fixed,
so probably not a big deal for the driver to handle.

-- 
Jesse Barnes, Intel Open Source Technology Center
