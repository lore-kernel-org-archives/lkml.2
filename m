Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab2E3TlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 15:41:09 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:37373 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752423Ab2E3TlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 15:41:07 -0400
Date: Wed, 30 May 2012 12:40:59 -0700
From: Mike Turquette <mturquette@ti.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] clk: add extension API
Message-ID: <20120530194059.GA13243@gmail.com>
References: <1338285540-24407-1-git-send-email-pdeschrijver@nvidia.com>
 <4FC5DFCF.1020606@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC5DFCF.1020606@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20120530-01:52, Stephen Boyd wrote:
> On 5/29/2012 2:58 AM, Peter De Schrijver wrote:
> > Add an extension API for clocks. This allows clocktypes to provide extensions
> > for features which are uncommon and cannot be easily mapped onto normal clock
> > framework concecpts. eg: resetting blocks, configuring clock phase etc.
> 
> This seems rather generic. Why not add more specific APIs/concepts like
> clk_reset(), clk_set_phase(), etc.? If they don't map, maybe we should
> make them map.
> 

I also wonder if exposing some of these knobs should be done in the
basic clock types.  Meaning that instead of having additional calls in
the clk.h API those calls could be exposed by the basic clock types that
map to the actions.

The question that needs to be answered is this: do generic drivers need
access to these additional functions (clk.h) or just the platform code
which implements some of the clock logic (basic clock types &
platform-speciic clock types).

Regards,
Mike

> At the least it should be documented so that people know what it should
> be used for.
