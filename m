Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277Ab1KBTym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 15:54:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44867 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab1KBTyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 15:54:41 -0400
Date: Wed, 2 Nov 2011 19:54:04 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Balbi <balbi@ti.com>
Cc: Nicolas Pitre <nico@fluxnic.net>, Stephen Warren <swarren@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Gary King <gking@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm/tegra: add support for tegra30 interrupts
Message-ID: <20111102195404.GF12913@n2100.arm.linux.org.uk>
References: <1320248292-22736-1-git-send-email-pdeschrijver@nvidia.com> <74CDBE0F657A3D45AFBB94109FB122FF173F9A46E5@HQMAIL01.nvidia.com> <74CDBE0F657A3D45AFBB94109FB122FF173F9A4758@HQMAIL01.nvidia.com> <74CDBE0F657A3D45AFBB94109FB122FF173F9A47A7@HQMAIL01.nvidia.com> <20111102192112.GC12913@n2100.arm.linux.org.uk> <20111102192625.GD14372@legolas.emea.dhcp.ti.com> <20111102193947.GD12913@n2100.arm.linux.org.uk> <20111102194827.GF14372@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111102194827.GF14372@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 09:48:28PM +0200, Felipe Balbi wrote:
> Hi,
> 
> you forgot to comment on the fact that gpio_desc shouldn't be held in an
> array. Any comments ?

I did not comment on that because that's someone elses problem.

> What I mean is that, just like irq_descs, we should be able to allocate
> them dynamically. Maybe, just like irq_descs, hold them in a radix tree
> and maybe even have a matching API "gpio_alloc_descs()".

Probably - I expect Grant would really like to see some patches along
those lines.  As I say, someone elses problem.

But what is _our_ problem is what to do with all the ARCH_NR_GPIOs
that we have now, and stop them increasing.  There is a trivial solution
to that which I outlined which can be used until GPIO gets something
along your idea - and which doesn't involve me having to argue with
those who think that the kernel should remain as small as possible.
