Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034Ab2EQJUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 05:20:21 -0400
Received: from linux-sh.org ([111.68.239.195]:52668 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757679Ab2EQJUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 05:20:19 -0400
Date: Thu, 17 May 2012 18:19:42 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Chen Liqin <liqin.chen@sunplusct.com>
Subject: Re: [PATCH v2 1/3] zsmalloc: support zsmalloc to ARM, MIPS, SUPERH
Message-ID: <20120517091942.GA24355@linux-sh.org>
References: <1337133919-4182-1-git-send-email-minchan@kernel.org>
 <20120517083213.GC14027@linux-sh.org>
 <4FB4BFB0.4010805@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB4BFB0.4010805@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 06:06:56PM +0900, Minchan Kim wrote:
> On 05/17/2012 05:32 PM, Paul Mundt wrote:
> > One thing you might consider is providing a stubbed definition that wraps
> > to flush_tlb_kernel_range() in the !SMP case, as this will extend your
> > testing coverage for staging considerably.
> 
> 
> AFAIUC, you mean following as,
> 
> ifndef CONFIG_SMP
> void flush_tlb_kernel_range(unsinged long start, unsigned log end)
> {
> 	local_flush_tlb_kernel_range(start, end);
> }
> #endif
> 
Actually I meant the opposite:

#ifndef CONFIG_SMP
#define local_flush_tlb_kernel_range flush_tlb_kernel_range
#endif

as the UP case is going to be local already. It's a bit hacky, though.
