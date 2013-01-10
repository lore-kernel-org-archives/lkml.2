Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab3AJScn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 13:32:43 -0500
Received: from 8bytes.org ([85.214.48.195]:56223 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754948Ab3AJScl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 13:32:41 -0500
Date: Thu, 10 Jan 2013 19:32:37 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hideki EIRAKU <hdk@igel.co.jp>, Katsuya MATSUBARA <matsu@igel.co.jp>,
        Russell King <linux@arm.linux.org.uk>,
        Simon Horman <horms@verge.net.au>, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Paul Mundt <lethal@linux-sh.org>,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 1/4] iommu/shmobile: Add iommu driver for Renesas
 IPMMU modules
Message-ID: <20130110183236.GG25591@8bytes.org>
References: <1356434355-3279-1-git-send-email-hdk@igel.co.jp>
 <1356434355-3279-2-git-send-email-hdk@igel.co.jp>
 <1586668.MmWlG9A4gq@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1586668.MmWlG9A4gq@avalon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jan 10 19:32:39 2013
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50ef094722971911816622
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jan 07, 2013 at 07:11:58PM +0100, Laurent Pinchart wrote:
> > +		l2index = (iova >> 12) & 0xff;
> > +		spin_lock(&sh_domain->map_lock);
> > +		ret = l2alloc(sh_domain, l1index);
> 
> l2alloc calls dma_pool_alloc(GFP_KERNEL), that not safe in a non-sleepable 
> context. Do we need a spinlock here, or could a mutex do ?

iommu_map should work in any context, so a mutex will not work. Also the
memory allocations in that path should be GFP_ATOMIC instead of
GFP_KERNEL.

Other than that this driver looks good from an IOMMU-API perspective.
Please Cc me on future versions of this patch-set directly.

Thanks,

	Joerg

