Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab1IFXyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 19:54:18 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:34656 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755355Ab1IFXyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 19:54:14 -0400
X-Sasl-enc: jha/KjSAsH98NajE6fx8cwWqkCa0fOqZSlmvUc1fYmoU 1315353253
Date: Tue, 6 Sep 2011 16:51:29 -0700
From: Greg KH <greg@kroah.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, dan.magenheimer@oracle.com,
        ngupta@vflare.org, cascardo@holoscopio.com, rdunlap@xenotime.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: zcache: xcfmalloc memory allocator for
 zcache
Message-ID: <20110906235129.GA26281@kroah.com>
References: <1314801641-15059-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1314801641-15059-2-git-send-email-sjenning@linux.vnet.ibm.com>
 <4E5FA81F.6060607@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E5FA81F.6060607@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 10:43:27AM -0500, Seth Jennings wrote:
> On 08/31/2011 09:40 AM, Seth Jennings wrote:
> 
> > +static struct xcf_blkdesc *xcf_find_remove_block(struct xcf_pool *pool,
> > +	int size, int blocknum)
> > +{
> > +	int flindex, i;
> > +	struct xcf_blkdesc *desc = NULL;
> > +
> > +	flindex = xcf_size_to_flindex(size + sizeof(struct xcf_blkhdr));
> > +
> > +	/* look for best fit */
> > +	if (pool->freelists[flindex])
> > +		goto remove;
> > +
> > +	/* if this is the last block allowed in the allocation, we shouldn't
> > +	 * consider smaller blocks.  it's all or nothing now */
> > +	if (blocknum == XCF_MAX_BLOCKS_PER_ALLOC) {
> 
> In gathering my performance numbers for Dan, I discovered I introduced
> a regression by making a late change in my development.
> 
> This line should be:
> 	if (blocknum != XCF_MAX_BLOCKS_PER_ALLOC) {
> 
> This regression actually causes xcfmalloc to have the same fragmentation
> issue as xvmalloc.

Ok, care to resend a tested and correct patch series then?

greg k-h
