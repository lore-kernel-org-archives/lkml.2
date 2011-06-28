Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab1F1XYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 19:24:48 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56818 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab1F1XYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 19:24:43 -0400
Date: Wed, 29 Jun 2011 00:24:29 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>, Rob Herring <rob.herring@calxeda.com>,
        nico@fluxnic.net
Subject: Re: [PATCH 2/4] ARM: remove unnecessary mach/hardware.h includes
Message-ID: <20110628232429.GI21898@n2100.arm.linux.org.uk>
References: <1309301859-17651-1-git-send-email-robherring2@gmail.com> <1309301859-17651-3-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309301859-17651-3-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 05:57:37PM -0500, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Remove some includes of mach/hardware.h which are not needed. hardware.h will
> be removed completely for tegra and cns3xxx in follow on patch.

At least this one is incorrect:

arch/arm/mach-rpc/include/mach/hardware.h:#define IO_EC_MEMC_BASE              0x80000000
arch/arm/kernel/ecard.c:                    address = IO_EC_MEMC_BASE + (slot << 12);

That's just one of the defines that ecard.c uses from mach/hardare.h.

