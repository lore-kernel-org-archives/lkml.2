Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab2GHQTa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 12:19:30 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63495 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab2GHQTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 12:19:10 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1207061008560.28648@router.home>
References: <1340389359-2407-1-git-send-email-js1304@gmail.com>
	<1340389359-2407-3-git-send-email-js1304@gmail.com>
	<alpine.DEB.2.00.1207050924330.4138@router.home>
	<CAAmzW4NJyX9e_dMyJBA5zDiVYVmL1vbUkaRHNoSbbhDZWW7iMg@mail.gmail.com>
	<alpine.DEB.2.00.1207060928580.26790@router.home>
	<CAAmzW4P941qeKy6UH079r73zR5VjUeNZNB53Mi4wiHE28f==gg@mail.gmail.com>
	<alpine.DEB.2.00.1207061008560.28648@router.home>
Date: Mon, 9 Jul 2012 01:19:09 +0900
Message-ID: <CAAmzW4PzJiBFDR3rKwVBn0Ex5cCR=qai6SA9_SbVH-psuh6nOQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] slub: release a lock if freeing object with a lock is
 failed in __slab_free()
From: JoonSoo Kim <js1304@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/7 Christoph Lameter <cl@linux.com>:
> On Fri, 6 Jul 2012, JoonSoo Kim wrote:
>
>> >> At CPU2, we don't need lock anymore, because this slab already in partial list.
>> >
>> > For that scenario we could also simply do a trylock there and redo
>> > the loop if we fail. But still what guarantees that another process will
>> > not modify the page struct between fetching the data and a successful
>> > trylock?
>>
>>
>> I'm not familiar with English, so take my ability to understand into
>> consideration.
>
> I have a hard time understanding what you want to accomplish here.
>
>> we don't need guarantees that another process will not modify
>> the page struct between fetching the data and a successful trylock.
>
> No we do not need that since the cmpxchg will then fail.
>
> Maybe it would be useful to split this patch into two?
>
> One where you introduce the dropping of the lock and the other where you
> get rid of certain code paths?
>

Dropping of the lock is need for getting rid of certain code paths.
So, I can't split this patch into two.

Sorry for confusing all the people.
I think that I don't explain my purpose well.
I will prepare new version in which I explain purpose of patch better.

Thanks for kind review.
