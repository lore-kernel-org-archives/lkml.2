Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab2BAKCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 05:02:25 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6302 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075Ab2BAKCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 05:02:24 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 01 Feb 2012 02:02:05 -0800
Date: Wed, 1 Feb 2012 12:01:53 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Olof Johansson <olof@lixom.net>
CC: Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/8] ARM: tegra: rework Tegra secondary CPU core
 bringup
Message-ID: <20120201100153.GM24948@tbergstrom-lnx.Nvidia.com>
References: <1328028051-24271-1-git-send-email-pdeschrijver@nvidia.com>
 <1328028051-24271-4-git-send-email-pdeschrijver@nvidia.com>
 <20120201075448.GI7399@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120201075448.GI7399@quad.lixom.net>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 08:54:48AM +0100, Olof Johansson wrote:
> On Tue, Jan 31, 2012 at 06:40:41PM +0200, Peter De Schrijver wrote:
> 
> > +	.align L1_CACHE_SHIFT
> > +	.type	__tegra_cpu_reset_handler_data, %object
> > +	.globl	__tegra_cpu_reset_handler_data
> > +__tegra_cpu_reset_handler_data:
> > +	.rept	TEGRA_RESET_DATA_SIZE
> > +	.long	0
> > +	.endr
> > +	.size	__tegra_cpu_reset_handler_data, .-tegra_cpu_reset_handler_data
> > +	.align L1_CACHE_SHIFT
> > +
> 
> This doesn't build:
> 
> /tmp/ccPd4Pcj.s: Assembler messages:
> /tmp/ccPd4Pcj.s: Error: .size expression for __tegra_cpu_reset_handler_data does not evaluate to a constant
> 
> Did you mean .-__tegra_cpu_reset_handler_data there?

Yes. It's not used anywhere though :) So I will leave it out in the next version.

Cheers,

Peter.
