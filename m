Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab0INRtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 13:49:07 -0400
Received: from freeflow.nu ([178.79.134.28]:33241 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab0INRtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 13:49:06 -0400
Message-ID: <4C8FB58F.8010706@kernel.org>
Date: Tue, 14 Sep 2010 20:49:03 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/2] SLUB: Fix merged slab cache names
References: <1284483964-2370-1-git-send-email-penberg@kernel.org> <alpine.DEB.2.00.1009141221310.31857@router.home> <4C8FB2AC.1030107@kernel.org> <alpine.DEB.2.00.1009141244330.444@router.home>
In-Reply-To: <alpine.DEB.2.00.1009141244330.444@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 14.9.2010 20.47, Christoph Lameter wrote:
> On Tue, 14 Sep 2010, Pekka Enberg wrote:
>
>>> Put this into mm/slub.c as slub only flag? What is the difference from
>>> refcount == 1?
>> I can put it in mm/slub.c but I was worried about someone reusing the bit for
>> something else.
> Allocate from the other end like __OBJECT_POISON.
I'll do that. Thanks!
>> Do you mean refcount == 2? You don't know during kmem cache release time if
>> someone was merged to the cache or not.
>>> Ok. Keeping the original name. Why dont we do strdup by default and always
>>> do a kfree(s->name) on close?
>>>
>> I tried that. It gets very nasty during bootstrap.
> Add it only to kmem_cache_create() not to kmem_cache_open. That is not
> used during bootstrap. The bootstrap caches do not matter since they are
> never freed
I tried that too. It doesn't work because we get merged to kmalloc 
caches and can't do kfree() on them.

             Pekka
