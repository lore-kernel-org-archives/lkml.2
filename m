Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531Ab0GVOK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 10:10:26 -0400
Received: from nox2.protox.org ([95.130.11.66]:55201 "EHLO protox.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759443Ab0GVOKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 10:10:24 -0400
Message-ID: <4C485145.6020101@freedesktop.org>
Date: Thu, 22 Jul 2010 10:10:13 -0400
From: Jerome Glisse <glisse@freedesktop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.4) Gecko/20100628 Red Hat/3.1-1.el6 Thunderbird/3.1
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, suokkos@gmail.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: questions about ttm_page_alloc.c
References: <20100712223905.GH5658@bicker> <4C3BA165.5020008@freedesktop.org> <20100722115628.GG17585@bicker>
In-Reply-To: <20100722115628.GG17585@bicker>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2010 07:56 AM, Dan Carpenter wrote:
> On Mon, Jul 12, 2010 at 07:12:37PM -0400, Jerome Glisse wrote:
>> On 07/12/2010 06:39 PM, Dan Carpenter wrote:
>>>      327                  pages_to_free[freed_pages++] = p;
>>>      328                  /* We can only remove NUM_PAGES_TO_ALLOC at a time. */
>>>      329                  if (freed_pages>= NUM_PAGES_TO_ALLOC) {
>>>      330                          /* remove range of pages from the pool */
>>>      331                          __list_del(p->lru.prev,&pool->list);
>>>
>>> 	Why do we use p->lru.prev here when we use&p->lru in other
>>> 	places?
>>>
>>>      332
>>>      333                          ttm_pool_update_free_locked(pool, freed_pages);
>>>      334                          /**
>>>      335                           * Because changing page caching is costly
>>>      336                           * we unlock the pool to prevent stalling.
>>>
>
> Thanks for answering about the wb vs uncached, but I'm still confused why we use
> &p->lru in most places and p->lru.prev in this place.
>
> regards,
> dan carpenter
>

This is because it use __list_del to remove a whole part of the list.

/*
  * Delete a list entry by making the prev/next entries
  * point to each other.
  *
  * This is only for internal list manipulation where we know
  * the prev/next entries already!
  */
static inline void __list_del(struct list_head * prev, struct list_head * next)
{
»·······next->prev = prev;
»·······prev->next = next;
}

Cheers,
Jerome
