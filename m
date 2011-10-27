Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab1J0O3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 10:29:12 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53470 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879Ab1J0O3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 10:29:11 -0400
Date: Thu, 27 Oct 2011 16:29:08 +0200
From: Mel Gorman <mel@csn.ul.ie>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] cache align vm_stat
Message-ID: <20111027142858.GB6563@csn.ul.ie>
References: <20111027085008.GA6563@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20111027085008.GA6563@csn.ul.ie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 10:50:25AM +0200, Mel Gorman wrote:
> On Mon, Oct 24, 2011 at 11:10:35AM -0500, Dimitri Sivanich wrote:
> > Avoid false sharing of the vm_stat array.
> > 
> > This was found to adversely affect tmpfs I/O performance.
> > 
> 
> I think this fix is overly simplistic.

In a lesson on why I should not even try reviewing while attending
conferences, I totally misread what the patch is doing. It's aligning
the array to avoid false sharing with other global data, not aligning
each element. This is reasonable.

Acked-by: Mel Gorman <mel@csn.ul.ie>
