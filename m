Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab2LGF7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 00:59:55 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:48392 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab2LGF7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 00:59:54 -0500
MIME-Version: 1.0
In-Reply-To: <50C124B7.4070502@canonical.com>
References: <1354810806-81681-1-git-send-email-tim.gardner@canonical.com>
	<CAPM=9ty_PfiQ9Cd5CRNnQbZ7Ea-69qCUR7JM=BA-n_egDnOE5g@mail.gmail.com>
	<50C124B7.4070502@canonical.com>
Date: Fri, 7 Dec 2012 15:59:53 +1000
Message-ID: <CAPM=9tyENuyjNYdRZM0Z-tWZsQ5TnHadtByXWv7yNE0j0gwxpQ@mail.gmail.com>
Subject: Re: [PATCH 3.7-rc8] ttm: Fix possible _manager memory allocation oops
From: Dave Airlie <airlied@gmail.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        dri-devel@lists.freedesktop.org, David Howells <dhowells@redhat.com>,
        Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 7, 2012 at 9:05 AM, Tim Gardner <tim.gardner@canonical.com> wrote:
> On 12/06/2012 03:46 PM, Dave Airlie wrote:
>
>>>
>>>          ttm_page_pool_init_locked(&_manager->wc_pool, GFP_HIGHUSER,
>>> "wc");
>>>
>>> @@ -817,6 +821,7 @@ int ttm_page_alloc_init(struct ttm_mem_global *glob,
>>> unsigned max_pages)
>>>                                     &glob->kobj, "pool");
>>>          if (unlikely(ret != 0)) {
>>>                  kobject_put(&_manager->kobj);
>>> +               kfree(_manager);
>>>                  _manager = NULL;
>>
>>
>> I don;t think this is, since the kobject_put shuold free it.
>>
>
> kobject_put only frees memory referenced by kobj, but not the memory pointed
> at by _manager.
>

The memory pointed at by _manager is the memory freed by the kobj if I
read the code correctly.

Dave.
