Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab0HWWfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 18:35:53 -0400
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:50577 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab0HWWfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 18:35:52 -0400
Message-ID: <4C72F7C6.3020109@hardwarefreak.com>
Date: Mon, 23 Aug 2010 17:35:50 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Christoph Lameter <cl@linux.com>, Mikael Abrahamsson <swmike@swm.pp.se>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: 2.6.34.1 page allocation failure
References: <4C70BFF3.8030507@hardwarefreak.com> <alpine.DEB.1.10.1008220842400.8562@uplift.swm.pp.se> <AANLkTin48SJ58HvFqjrOnQBMqLcbECtqXokweV00dNgv@mail.gmail.com> <alpine.DEB.2.00.1008221734410.21916@router.home> <4C724141.8060000@kernel.org>
In-Reply-To: <4C724141.8060000@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg put forth on 8/23/2010 4:37 AM:
>  On 8/23/10 1:40 AM, Christoph Lameter wrote:
>> On Sun, 22 Aug 2010, Pekka Enberg wrote:
>>
>>> In Stan's case, it's a order-1 GFP_ATOMIC allocation but there are
>>> only order-0 pages available. Mel, any recent page allocator fixes in
>>> 2.6.35 or 2.6.36-rc1 that Stan/Mikael should test?
>> This is the TCP slab? Best fix would be in the page allocator. However,
>> in this particular case the slub allocator would be able to fall back to
>> an order 0 allocation and still satisfy the request.
>>
> Looking at the stack trace of the oops, I think Stan has CONFIG_SLAB
> which doesn't have order-0 fallback.

That is correct.  The menuconfig help screen led me to believe the SLAB
allocator was the "safe" choice:

"CONFIG_SLAB:
The regular slab allocator that is established and known to work well in
all environments"

Should I be using SLUB instead?  Any downsides to SLUB on an old and
slow (500 MHz) single core dual CPU box with <512MB RAM?

Also, what is the impact of these oopses?  Despite the entries in dmesg,
the system "seems" to be running ok.  Or is this simply the calm before
the impending storm?

-- 
Stan
