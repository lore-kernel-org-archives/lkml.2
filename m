Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab0GaVmx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 17:42:53 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46181 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab0GaVmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 17:42:51 -0400
Date: Sat, 31 Jul 2010 22:42:42 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] cyber2000fb: add I2C support
Message-ID: <20100731214242.GB3633@n2100.arm.linux.org.uk>
References: <201007312255.51139.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007312255.51139.linux@rainbow-software.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 31, 2010 at 10:55:49PM +0200, Ondrej Zary wrote:
> Add I2C support for the DDC bus to cyber2000fb driver. This is only bus
> support, driver does not use EDID.
> Tested on two different CyberPro 2000 cards with i2cdetect and decode-edid.

I'm debating a bit about this.

One thing I'm concerned about is switching the DCLK registers to DCC
mode without any protection against mode changes co-inciding with
I2C activity.  On a SMP machine, it's possible for both to happen
simultaneously.

Secondly, please name these I2C bits with 'ddc' in the name - the
CyberPro appear to have more than one I2C bus on them (or can have)
such as for driving SAA7111 video decoders.
