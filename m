Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab1JTTVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 15:21:52 -0400
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:59124
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab1JTTVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 15:21:51 -0400
Message-ID: <4EA074CD.9000903@kernel.dk>
Date: Thu, 20 Oct 2011 21:21:49 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] block: initialize the bounce pool if high memory may
 be added later
References: <1318334018-3312-1-git-send-email-david.vrabel@citrix.com> <4EA03DDC.9070808@citrix.com>
In-Reply-To: <4EA03DDC.9070808@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-20 17:27, David Vrabel wrote:
> On 11/10/11 12:53, David Vrabel wrote:
>> init_emergency_pool() does not create the page pool for bouncing block
>> requests if the current count of high pages is zero.  If high memory
>> may be added later (either via memory hotplug or a balloon driver in a
>> virtualized system) then a oops occurs if a request with a high page
>> need bouncing because the pool does not exist.
>>
>> So, always create the pool if memory hotplug is enabled and change the
>> test so it's valid even if all high pages are currently in the balloon
>> (the balloon drivers adjust totalhigh_pages but not max_pfn).
> 
> Jens, you don't seem to have picked up this patch yet.  Should it have
> gone via Andrew Morton instead?

Added now for 3.2.

-- 
Jens Axboe

