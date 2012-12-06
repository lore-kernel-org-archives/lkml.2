Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab2LFXFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 18:05:35 -0500
Received: from mail.tpi.com ([70.99.223.143]:1341 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab2LFXFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 18:05:34 -0500
Message-ID: <50C124B7.4070502@canonical.com>
Date: Thu, 06 Dec 2012 16:05:27 -0700
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        dri-devel@lists.freedesktop.org, David Howells <dhowells@redhat.com>,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH 3.7-rc8] ttm: Fix possible _manager memory allocation
 oops
References: <1354810806-81681-1-git-send-email-tim.gardner@canonical.com> <CAPM=9ty_PfiQ9Cd5CRNnQbZ7Ea-69qCUR7JM=BA-n_egDnOE5g@mail.gmail.com>
In-Reply-To: <CAPM=9ty_PfiQ9Cd5CRNnQbZ7Ea-69qCUR7JM=BA-n_egDnOE5g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2012 03:46 PM, Dave Airlie wrote:

>>
>>          ttm_page_pool_init_locked(&_manager->wc_pool, GFP_HIGHUSER, "wc");
>>
>> @@ -817,6 +821,7 @@ int ttm_page_alloc_init(struct ttm_mem_global *glob, unsigned max_pages)
>>                                     &glob->kobj, "pool");
>>          if (unlikely(ret != 0)) {
>>                  kobject_put(&_manager->kobj);
>> +               kfree(_manager);
>>                  _manager = NULL;
>
> I don;t think this is, since the kobject_put shuold free it.
>

kobject_put only frees memory referenced by kobj, but not the memory 
pointed at by _manager.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
