Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab2HNGSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 02:18:18 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55805 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab2HNGSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 02:18:17 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-04-5029eda7ef02
Date: Tue, 14 Aug 2012 15:20:16 +0900
From: Minchan Kim <minchan@kernel.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [PATCH 0/7] zram/zsmalloc promotion
Message-ID: <20120814062016.GA31621@bbox>
References: <1344406340-14128-1-git-send-email-minchan@kernel.org>
 <20120814023530.GA9787@kroah.com>
 <5029E3EF.9080301@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5029E3EF.9080301@vflare.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nitin,

On Mon, Aug 13, 2012 at 10:36:47PM -0700, Nitin Gupta wrote:
> On 08/13/2012 07:35 PM, Greg Kroah-Hartman wrote:
> > On Wed, Aug 08, 2012 at 03:12:13PM +0900, Minchan Kim wrote:
> >> This patchset promotes zram/zsmalloc from staging.
> >> Both are very clean and zram is used by many embedded product
> >> for a long time.
> >>
> >> [1-3] are patches not merged into linux-next yet but needed
> >> it as base for [4-5] which promotes zsmalloc.
> >> Greg, if you merged [1-3] already, skip them.
> > 
> > I've applied 1-3 and now 4, but that's it, I can't apply the rest
> > without getting acks from the -mm maintainers, sorry.  Please work with
> > them to get those acks, and then I will be glad to apply the rest (after
> > you resend them of course...)
> >
> 
> On a second thought, I think zsmalloc should stay in drivers/block/zram
> since zram is now the only user of zsmalloc since zcache and ramster are
> moving to another allocator. Secondly, zsmalloc does not provide
> standard slab like interface, so should not be part of mm/. At the best,
> it could be moved to lib/ with header in include/linux just like genalloc.

I don't care whether it's located in /mm or wherever.
But if we move it into out of /mm, I would like to confirm it from akpm.
AFAIRC, he had a concern about that because zsmalloc used a few fields of 
struct page freely so he wanted to locate it in /mm.

Andrew, Any thought?

>-- 
Kind regards,
Minchan Kim
