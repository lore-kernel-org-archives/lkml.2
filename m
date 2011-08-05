Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab1HEQPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 12:15:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49065 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753623Ab1HEQPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 12:15:22 -0400
Date: Sat, 6 Aug 2011 01:15:13 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Liam Girdwood <lrg@ti.com>,
        Chris Ball <cjb@laptop.org>, "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 1/3] irq: If an IRQ is a GPIO, request and configure it
Message-ID: <20110805161511.GB3438@opensource.wolfsonmicro.com>
References: <1312498820-2275-1-git-send-email-swarren@nvidia.com>
 <1312498820-2275-2-git-send-email-swarren@nvidia.com>
 <20110805000148.GB13321@opensource.wolfsonmicro.com>
 <74CDBE0F657A3D45AFBB94109FB122FF049F171EC1@HQMAIL01.nvidia.com>
 <20110805053510.GA16956@opensource.wolfsonmicro.com>
 <74CDBE0F657A3D45AFBB94109FB122FF049F171EF4@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF049F171EF4@HQMAIL01.nvidia.com>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 08:29:38AM -0700, Stephen Warren wrote:
> Mark Brown wrote at Thursday, August 04, 2011 11:35 PM:

> > But it's not a bug to use a GPIO as an IRQ source, otherwise we wouldn't
> > have gpio_to_irq() in the first place.

> 2) Two pieces of unrelated code somehow accidentally get a GPIO and IRQ
> number that map to the same resource, e.g. due to incorrect board files or
> Device Tree content. This is probably a bug, but ends up looking exactly
> the same as far as the IRQ code's gpio_request call failing in the patch I
> posted.

Right, but this doesn't mean we can break the legitimate users to catch
the buggy ones.
