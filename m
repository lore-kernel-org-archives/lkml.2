Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab1FNRMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 13:12:46 -0400
Received: from bhuna.collabora.co.uk ([93.93.128.226]:45903 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab1FNRMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 13:12:42 -0400
X-Greylist: delayed 642 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jun 2011 13:12:42 EDT
Date: Tue, 14 Jun 2011 18:01:58 +0100
From: Daniel Stone <daniels@collabora.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Nazarewicz <mina86@mina86.com>, "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'Mel Gorman'" <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH 08/10] mm: cma: Contiguous Memory
 Allocator added
Message-ID: <20110614170158.GU2419@fooishbar.org>
Mail-Followup-To: Daniel Stone <daniels@collabora.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Michal Nazarewicz <mina86@mina86.com>,
	'Ankita Garg' <ankita@in.ibm.com>,
	'Daniel Walker' <dwalker@codeaurora.org>,
	'Jesse Barker' <jesse.barker@linaro.org>,
	'Mel Gorman' <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'KAMEZAWA Hiroyuki' <kamezawa.hiroyu@jp.fujitsu.com>,
	'Andrew Morton' <akpm@linux-foundation.org>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com>
 <201106141549.29315.arnd@arndb.de>
 <op.vw2jmhir3l0zgt@mnazarewicz-glaptop>
 <201106141803.00876.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106141803.00876.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 14, 2011 at 06:03:00PM +0200, Arnd Bergmann wrote:
> On Tuesday 14 June 2011, Michal Nazarewicz wrote:
> > On Tue, 14 Jun 2011 15:49:29 +0200, Arnd Bergmann <arnd@arndb.de> wrote:
> > > Please explain the exact requirements that lead you to defining multiple
> > > contexts.
> > 
> > Some devices may have access only to some banks of memory.  Some devices
> > may use different banks of memory for different purposes.
> 
> For all I know, that is something that is only true for a few very special
> Samsung devices, and is completely unrelated of the need for contiguous
> allocations, so this approach becomes pointless as soon as the next
> generation of that chip grows an IOMMU, where we don't handle the special
> bank attributes. Also, the way I understood the situation for the Samsung
> SoC during the Budapest discussion, it's only a performance hack, not a
> functional requirement, unless you count '1080p playback' as a functional
> requirement.

Hm, I think that was something similar but not quite the same: talking
about having allocations split to lie between two banks of RAM to
maximise the read/write speed for performance reasons.  That's something
that can be handled in the allocator, rather than an API constraint, as
this is.

Not that I know of any hardware which is limited as such, but eh.

Cheers,
Daniel
