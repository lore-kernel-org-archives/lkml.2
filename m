Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab0HWJhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 05:37:09 -0400
Received: from freeflow.nu ([178.79.134.28]:60086 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087Ab0HWJhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 05:37:07 -0400
Message-ID: <4C724141.8060000@kernel.org>
Date: Mon, 23 Aug 2010 12:37:05 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Mikael Abrahamsson <swmike@swm.pp.se>,
        Stan Hoeppner <stan@hardwarefreak.com>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: 2.6.34.1 page allocation failure
References: <4C70BFF3.8030507@hardwarefreak.com> <alpine.DEB.1.10.1008220842400.8562@uplift.swm.pp.se> <AANLkTin48SJ58HvFqjrOnQBMqLcbECtqXokweV00dNgv@mail.gmail.com> <alpine.DEB.2.00.1008221734410.21916@router.home>
In-Reply-To: <alpine.DEB.2.00.1008221734410.21916@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 8/23/10 1:40 AM, Christoph Lameter wrote:
> On Sun, 22 Aug 2010, Pekka Enberg wrote:
>
>> In Stan's case, it's a order-1 GFP_ATOMIC allocation but there are
>> only order-0 pages available. Mel, any recent page allocator fixes in
>> 2.6.35 or 2.6.36-rc1 that Stan/Mikael should test?
> This is the TCP slab? Best fix would be in the page allocator. However,
> in this particular case the slub allocator would be able to fall back to
> an order 0 allocation and still satisfy the request.
>
Looking at the stack trace of the oops, I think Stan has CONFIG_SLAB 
which doesn't have order-0 fallback.

