Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab0GVL5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 07:57:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45232 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab0GVL47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 07:56:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=EdidxJDvtY24EGg43dAAZrax30AtQ08JBQpfTQOKNyJ/nB5w3uNNyITLnibbxUx2Yd
         eoNgwgMfO1NRt7qKlkJvM86NPgT15Rrdi0tX3jjULX5sHEnlHAlvCNxEtF5FfvAxYxnX
         1UoPNx2y2xDhf/16xaXNe5FEBDFc5zZy/mskQ=
Date: Thu, 22 Jul 2010 13:56:28 +0200
From: Dan Carpenter <error27@gmail.com>
To: Jerome Glisse <glisse@freedesktop.org>
Cc: suokkos@gmail.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: questions about ttm_page_alloc.c
Message-ID: <20100722115628.GG17585@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Jerome Glisse <glisse@freedesktop.org>, suokkos@gmail.com,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20100712223905.GH5658@bicker> <4C3BA165.5020008@freedesktop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3BA165.5020008@freedesktop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 07:12:37PM -0400, Jerome Glisse wrote:
> On 07/12/2010 06:39 PM, Dan Carpenter wrote:
>>     327                  pages_to_free[freed_pages++] = p;
>>     328                  /* We can only remove NUM_PAGES_TO_ALLOC at a time. */
>>     329                  if (freed_pages>= NUM_PAGES_TO_ALLOC) {
>>     330                          /* remove range of pages from the pool */
>>     331                          __list_del(p->lru.prev,&pool->list);
>>
>> 	Why do we use p->lru.prev here when we use &p->lru in other
>> 	places?
>>
>>     332
>>     333                          ttm_pool_update_free_locked(pool, freed_pages);
>>     334                          /**
>>     335                           * Because changing page caching is costly
>>     336                           * we unlock the pool to prevent stalling.
>>

Thanks for answering about the wb vs uncached, but I'm still confused why we use
&p->lru in most places and p->lru.prev in this place.

regards,
dan carpenter

