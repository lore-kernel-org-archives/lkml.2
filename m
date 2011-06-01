Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032Ab1FAVvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 17:51:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53142 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758812Ab1FAVvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 17:51:43 -0400
Date: Wed, 1 Jun 2011 23:51:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Daniel Haid <d.haid@gogi.tv>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        alexdeucher@gmail.com, airlied@redhat.com
Subject: Re: Question about iommu on x86_64 and radeon driver.
Message-ID: <20110601215138.GG27166@one.firstfloor.org>
References: <20110527155507.GB11273@dumpdata.com> <9e26ea71798d10a3f900c777b71ff485@admin.gogi.tv> <20110531134519.GC14641@dumpdata.com> <59be1730ec1660abeb7b4dc584510d34@admin.gogi.tv> <20110531160221.GA31659@dumpdata.com> <0a8cb4bcad7fcf091a6bbe158323bba0@admin.gogi.tv> <20110531190412.GA21245@dumpdata.com> <d0ce6a4ba6092a1a9ef0f1e8f3cac9c9@admin.gogi.tv> <20110601132444.GA4081@dumpdata.com> <21491fcfb013e21177140326efc0ee66@admin.gogi.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21491fcfb013e21177140326efc0ee66@admin.gogi.tv>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 05:10:44PM +0100, Daniel Haid wrote:
> >Look in the source code. I somehow assumed it would activate it
> >but maybe it isn't. And the problem you have is related to
> >something else?
> 
> If I have read the code correctly the only way to get
> swiotlb_force=1 in lib/swiotlb.c is to add the "swiotlb=force"
> argument to the kernel parameters.
> 
> Without it on VIA chipsets swiotlb gets activated, but with
> swiotlb_force=0. In this case DMA to addresses below 4GB should be
> direct.
> 
> But since I still get the error the radeon driver must (incorrectly)
> allocate memory above 4GB somewhere, but where?

Someone has to debug it. grep for the error message, read the 
surrounding code, add printks, run it, until you figure out which allocation
has the problem.

Adding some radeon driver people to cc. The original problem
is described in http://choon.net/forum/read.php?21,106131,115940

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
