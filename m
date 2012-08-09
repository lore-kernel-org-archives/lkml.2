Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab2HIKGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 06:06:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49216 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757521Ab2HIKGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 06:06:51 -0400
Date: Thu, 9 Aug 2012 11:06:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] mfd: add lp8788 mfd driver
Message-ID: <20120809100648.GF24328@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EEBC45@DBDE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EEBC45@DBDE02.ent.ti.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 08:22:38AM +0000, Kim, Milo wrote:
> TI LP8788 PMU supports regulators, battery charger, RTC,
> ADC, backlight driver and current sinks.

> Patch v2.
> (a) For interrupt handling, use generic irq rather than irq-domain

This seems like a very substantial step backwards, why make this change?
Using irqdomain solves a bunch of problems, especially around virq
allocation, and is where we want all drivers to go longer term.
