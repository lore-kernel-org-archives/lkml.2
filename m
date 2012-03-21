Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab2CUQJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 12:09:17 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41893 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab2CUQJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 12:09:16 -0400
Date: Wed, 21 Mar 2012 09:09:10 -0700
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Patch workqueue: create new slab cache instead of hacking
Message-ID: <20120321160910.GB4246@google.com>
References: <1332238884-6237-1-git-send-email-laijs@cn.fujitsu.com>
 <1332238884-6237-7-git-send-email-laijs@cn.fujitsu.com>
 <20120320154619.GA5684@google.com>
 <4F6944D9.5090002@cn.fujitsu.com>
 <CAOS58YPydFUap4HjuRATxza6VZgyrXmQHVxR83G7GRJL50ZTRQ@mail.gmail.com>
 <alpine.DEB.2.00.1203210910450.20482@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1203210910450.20482@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 09:12:04AM -0500, Christoph Lameter wrote:
> How about this instead?
> 
> Subject: workqueues: Use new kmem cache to get aligned memory for workqueues
> 
> The workqueue logic currently improvises by doing a kmalloc allocation and
> then aligning the object. Create a slab cache for that purpose with the
> proper alignment instead.
> 
> Cleans up the code and makes things much simpler. No need anymore to carry
> an additional pointer to the beginning of the kmalloc object.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

I don't know.  At this point, this is only for singlethread and
unbound workqueues and we don't have too many of them left at this
point.  I'd like to avoid creating a slab cache for this.  How about
just leaving it be?  If we develop other use cases for larger
alignments, let's worry about implementing something common then.

Thanks.

-- 
tejun
