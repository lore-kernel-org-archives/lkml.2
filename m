Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab2EaHwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 03:52:47 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4729 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757874Ab2EaHwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 03:52:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 31 May 2012 00:50:12 -0700
Date: Thu, 31 May 2012 10:51:25 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [RFC PATCH] clk: add extension API
Message-ID: <20120531075125.GL8026@tbergstrom-lnx.Nvidia.com>
References: <1338285540-24407-1-git-send-email-pdeschrijver@nvidia.com>
 <4FC5DFCF.1020606@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FC5DFCF.1020606@codeaurora.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 10:52:31AM +0200, Stephen Boyd wrote:
> On 5/29/2012 2:58 AM, Peter De Schrijver wrote:
> > Add an extension API for clocks. This allows clocktypes to provide extensions
> > for features which are uncommon and cannot be easily mapped onto normal clock
> > framework concecpts. eg: resetting blocks, configuring clock phase etc.
> 
> This seems rather generic. Why not add more specific APIs/concepts like
> clk_reset(), clk_set_phase(), etc.? If they don't map, maybe we should
> make them map.
> 

Some of those might be very SoC specific. Eg OMAP doesn't need software
controlled modulereset. I don't think we should add a new function to the
clock framework for clock related features which only exist in a single
SoC or family. Ideally we could use inheritance to add methods to derived
clocktypes, but that's not really possible in C unfortunately.

Cheers,

Peter.
