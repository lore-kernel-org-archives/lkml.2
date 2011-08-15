Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab1HOIoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 04:44:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38244 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab1HOIoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 04:44:22 -0400
Message-ID: <4E48DC61.9080903@kernel.org>
Date: Mon, 15 Aug 2011 11:44:17 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Christoph Lameter <cl@linux.com>, Andi Kleen <andi@firstfloor.org>,
        tj@kernel.org, Metathronius Galabant <m.galabant@googlemail.com>,
        Matt Mackall <mpm@selenic.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Adrian Drzewiecki <z@drze.net>, linux-kernel@vger.kernel.org
Subject: Re: [slub p4 0/7] slub: per cpu partial lists V4
References: <20110809211221.831975979@linux.com> <alpine.DEB.2.00.1108131118001.32762@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1108131118001.32762@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/13/11 9:28 PM, David Rientjes wrote:
> On Tue, 9 Aug 2011, Christoph Lameter wrote:
>
>> The following patchset introduces per cpu partial lists which allow
>> a performance increase of around ~10-20% with hackbench on my Sandybridge
>> processor.
>>
>> These lists help to avoid per node locking overhead. Allocator latency
>> could be further reduced by making these operations work without
>> disabling interrupts (like the fastpath and the free slowpath) but that
>> is another project.
>>
>> It is interesting to note that BSD has gone to a scheme with partial
>> pages only per cpu (source: Adrian). Transfer of cpu ownerships is
>> done using IPIs. Probably too much overhead for our taste. The approach
>> here keeps the per node partial lists essentially meaning the "pages"
>> in there have no cpu owner.
>>
>
> I'm currently 35,000 feet above Chicago going about 611 mph, so what
> better time to benchmark this patchset on my netperf testing rack!
>
> 	threads		before		after
> 	 16		78031		74714  (-4.3%)
> 	 32		118269		115810 (-2.1%)
> 	 48		150787		150165 (-0.4%)
> 	 64		189932		187766 (-1.1%)
> 	 80		221189		223682 (+1.1%)
> 	 96		239807		246222 (+2.7%)
> 	112		262135		271329 (+3.5%)
> 	128		273612		286782 (+4.8%)
> 	144		280009		293943 (+5.0%)
> 	160		285972		299798 (+4.8%)
>
> I'll review the patchset in detail, especially the cleanups and
> optimizations, when my wifi isn't so sketchy.

Andi, it'd be interesting to know your results for v4 of this patchset. 
I'm hoping to get the patches reviewed and merged to linux-next this week.

			Pekka
