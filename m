Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab2FLTHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 15:07:35 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:47551 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752052Ab2FLTHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 15:07:34 -0400
Date: Tue, 12 Jun 2012 12:07:28 -0700
From: Mike Turquette <mturquette@ti.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] clk: Allow late cache allocation for clk->parents
Message-ID: <20120612190728.GI19410@gmail.com>
References: <1338973891-28719-1-git-send-email-rnayak@ti.com>
 <1338973891-28719-3-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338973891-28719-3-git-send-email-rnayak@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20120606-14:41, Rajendra Nayak wrote:
> Parent clocks for muxes are cached in clk->parents to
> avoid frequent lookups, however the cache allocation happens
> only during clock registeration and later clk_set_parent()
> assumes a cache space available and allocated.
> 
> This is not entirely true for platforms which do early clock
> registerations wherein the cache allocation using kzalloc
> could fail during clock registeration.
> 
> Allow cache allocation to happen later as part of clk_set_parent()
> to help such cases and avoid crashes assuming a cache being
> available.
> 
> While here also replace existing kmalloc() with kzalloc()
> in the file.
> 
> Signed-off-by: Rajendra Nayak <rnayak@ti.com>

I've taken this patch into clk-next for testing.

Thanks,
Mike
