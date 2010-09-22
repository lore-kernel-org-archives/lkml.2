Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab0IVJYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 05:24:03 -0400
Received: from mgw-sa01.nokia.com ([147.243.1.47]:61485 "EHLO
	mgw-sa01.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab0IVJYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 05:24:01 -0400
Date: Wed, 22 Sep 2010 12:22:28 +0300
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: "mingo@elte.hu" <mingo@elte.hu>, "gregkh@suse.de" <gregkh@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "travis@sgi.com" <travis@sgi.com>,
        "akataria@vmware.com" <akataria@vmware.com>, tony@atomide.com,
        linux-omap@vger.kernel.org
Subject: Re: [RFC 0/3] Improve fallback LPJ calculation
Message-ID: <20100922092228.GJ2926@esdhcp04044.research.nokia.com>
References: <1284112468-18498-1-git-send-email-ext-phil.2.carmody@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284112468-18498-1-git-send-email-ext-phil.2.carmody@nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adding Tony and Linux-OMAP cc:, as this patchset was written specifically
with the OMAP in mind (thread rooted at http://lkml.org/lkml/2010/9/10/104 ).
Any comments would be appreciated.

Phil

On 10/09/10 11:54 +0200, Carmody Phil.2 (EXT-Ixonos/Helsinki) wrote:
> 
> The motivation for patch 2/3 is that currently our OMAP calibrates
> itself using the trial-and-error binary chop fallback that some other
> architectures no longer need to perform. This is a lengthy process, 
> taking 0.2s in an environment where boot time is of great interest.
> 
> The patch has two optimisations. Firstly, it replaces the initial 
> repeated-doubling to find the relevant power of 2 with a tight loop 
> that just does as much as it can in a jiffy. Secondly, it doesn't 
> binary chop over an entire power of 2 range, it choses a much smaller
> range based on how much it squeezed in, and failed to squeeze in, 
> during the first stage. Both are significant optimisations, and 
> bring our calibration down from 23 jiffies to 6, and, in the process,
> arrive at a more accurate lpj value.
> 
> The 'bands' and 'sub-logarithmic' growth may look over-engineered,
> but they cost a small level of in inaccuracy of the initial guess
> (for all architectures) in order to avoid the very large inaccuracies 
> that appeared during testing (on x86_64 architectures, and presumably 
> others with less metronomic operation). Note that due to the existence
> of the TSC and other timers, the x86_64 doesn't use this fallback 
> routine, but I wanted to code defensively, able to cope with all kinds
> of processor behaviours.
> 
> 1/3 is simply cosmetic to prepare for 2/3. 
> 3/3 is simply to assist testing and not intended for integration.
> 
> I would appreciate it if people with exotic or unusual architectures
> could help test this.
> 
> Cheers,
> Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
