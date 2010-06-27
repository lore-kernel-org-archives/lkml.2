Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab0F0JR4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 05:17:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701Ab0F0JRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 05:17:55 -0400
Message-ID: <4C271736.5010102@redhat.com>
Date: Sun, 27 Jun 2010 12:17:42 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Slow vmalloc in 2.6.35-rc3
References: <4C232324.7070305@redhat.com> <20100624151427.GH10441@laptop>
In-Reply-To: <20100624151427.GH10441@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2010 06:14 PM, Nick Piggin wrote:
> On Thu, Jun 24, 2010 at 12:19:32PM +0300, Avi Kivity wrote:
>    
>> I see really slow vmalloc performance on 2.6.35-rc3:
>>      
> Can you try this patch?
> http://userweb.kernel.org/~akpm/mmotm/broken-out/mm-vmap-area-cache.patch
>    

The patch completely eliminates the problem.

>>
>> It seems completely wrong - iterating 8 levels of a binary tree
>> shouldn't take half a millisecond.
>>      
> It's not iterating down the tree, it's iterating through the
> nodes to find a free area. Slows down because lazy vunmap means
> that quite a lot of little areas build up right at the start of
> our search start address. The vmap cache should hopefully fix
> it up.
>    

I see, thanks.

-- 
error compiling committee.c: too many arguments to function

