Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab1AGCBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 21:01:20 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:53410 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab1AGCBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 21:01:17 -0500
Date: Fri, 7 Jan 2011 10:59:18 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-sh@vger.kernel.org, Magnus Damm <damm@opensource.se>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: shdma: don't register the global die notifier multiple times
Message-ID: <20110107015918.GI22477@linux-sh.org>
References: <Pine.LNX.4.64.1101061759460.1248@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1101061759460.1248@axis700.grange>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 06:04:50PM +0100, Guennadi Liakhovetski wrote:
> A recent patch has added a die notifier to the shdma driver, however, 
> it registers a static die-notifier object in the probe routine, i.e., 
> for each device instance. This is wrong and leads to a system lockup. 
> This patch moves the die notifier registration to module init and 
> exit routines respectively.
> 
> Reported-by: Magnus Damm <damm@opensource.se>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> This fixes the lock up on sh7372. Patch against current sh-2.6/master.
> 
Whoops, I suppose I should have tested on a platform with more than one
DMAC :-)

I'll piggyback this on top of the rmobile-latest branch, thanks.
