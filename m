Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499Ab0I1H1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 03:27:22 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.38]:44895 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab0I1H1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 03:27:20 -0400
Message-ID: <4CA1990E.9080206@ladisch.de>
Date: Tue, 28 Sep 2010 09:28:14 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jimmie Mayfield <mayfield@sackheads.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Trying to reset a PCIe device and scratching my head...
References: <20100928020548.GA90230@sackheads.org>
In-Reply-To: <20100928020548.GA90230@sackheads.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jimmie Mayfield wrote:
> Having the PCIe interface implemented inside FPGA 'A' makes upgrading
> that particular FPGA rather troublesome.  In a perfect world, one would
> be able to upgrade the FPGA without having to reboot the machine.  The
> hardware guys have designed the card to reload that FPGA image upon a
> slot reset...either fundamental or hot.
> 
> So I'd like to be able to send either a fundamental or hot reset to the
> device but so far I've had no success.

The PCIe AER driver (drivers/pci/pcie/aer/) sends a hot reset when
it has received a fatal error.  As far as I can tell, it just sets the
PCI_BRIDGE_CTL_BUS_RESET bit of the upstream bridge; everything else
is just infrastructure to handle error reporting and to notify the
device driver about the reset.


Regards,
Clemens
