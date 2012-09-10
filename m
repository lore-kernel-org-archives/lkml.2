Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab2IJCpI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 22:45:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258Ab2IJCpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 22:45:06 -0400
Message-ID: <504D5433.6080403@redhat.com>
Date: Mon, 10 Sep 2012 10:45:07 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [ 84/95] virtio_blk: fix config handler race
References: <20120909224202.102918910@decadent.org.uk> <87392qfw9u.fsf@rustcorp.com.au>
In-Reply-To: <87392qfw9u.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 10:26 AM, Rusty Russell wrote:
> Ben Hutchings <ben@decadent.org.uk> writes:
> 
>> 3.2-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: "Michael S. Tsirkin" <mst@redhat.com>
>>
>> commit 4678d6f970c2f7c0cbfefc0cc666432d153b321b upstream.
>>
>> Fix a theoretical race related to config work
> 
> ???
> 
> From Documentation/stable_kernel_rules.txt:
> 
>  - No "theoretical race condition" issues, unless an explanation of how the
>    race can be exploited is also provided.
> 
> Similarly, '[ 85/95] virtio_blk: Drop unused request tracking list'
> is a marginal perf improvement, why is it in there?

This also drops the following line which may trigger a BUG in hot
-unplug path.

       /* Nothing should be pending. */
       BUG_ON(!list_empty(&vblk->reqs));

So, this patch is needed to fix up the hot-unplug bug along with the others.

> 
> Neither of these were cc:stable; did someone request them specifically?
> 
> Confused,
> Rusty.
> 


-- 
Asias
