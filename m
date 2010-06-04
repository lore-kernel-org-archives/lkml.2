Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab0FDSoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 14:44:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754480Ab0FDSoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 14:44:17 -0400
Date: Fri, 4 Jun 2010 11:42:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: albert_herranz@yahoo.es, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, jeremy@goop.org,
       iommu@lists.linux-foundation.org, linux@arm.linux.org.uk,
       dwmw2@infradead.org, chrisw@sous-sol.org, Ian.Campbell@eu.citrix.com,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] swiotlb-0.8.2: seperation of physical/virtual address
 translation and core memory allocation.
Message-Id: <20100604114250.b28f288a.akpm@linux-foundation.org>
In-Reply-To: <1275673955-30267-1-git-send-email-konrad.wilk@oracle.com>
References: <1275673955-30267-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  4 Jun 2010 13:52:30 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> Please include the following patches, located at this git tree:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git swiotlb-0.8.2
> 
> in your -mm tree.

I don't put individual git trees into -mm any more - I get them from
linux-next.

I could grab the individual patches but I don't see that this gains
anyone anything.  I'd suggest that you ask Stephen to include this tree
in linux-next then ask Linus to pull it into 2.6.36-rc1.

> [nice description]

The sad thing is that this description will get lost because it isn't
attached to a particular patch.  So what I do is to copy the nice
covering description into the changelog for [patch 1/n] and then, after
it I put the text

This patch:

and then follow it with the specific description for [patch 1/n].  I
suggest that you make such change in this tree.

It's not a very good solution because anyone who is looking at [patch
5/n] isn't likely to think to look in some other patch for the overall
story.  I guess it would be better if patches 2..n included the text
"see <patch name> for a description of this work" or similar.

Even better would be if git understood this workflow - if it was able
to take commentary-only commits and to bidirectionally link those
commentaries to the invividual commits which they describe.

The patches themselves look good and suitably reviewed to me.  My one
very minor comment is that include/linux/swiotlb.h ends up with a
mixture of "enum dma_data_direction dir" and "enum dma_data_direction
direction", which could be cleaned up.

