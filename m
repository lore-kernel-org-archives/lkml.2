Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab2FJK13 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 06:27:29 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44117 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab2FJK11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 06:27:27 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1206081403380.28466@router.home>
References: <1339176197-13270-1-git-send-email-js1304@gmail.com>
	<1339176197-13270-4-git-send-email-js1304@gmail.com>
	<alpine.DEB.2.00.1206081403380.28466@router.home>
Date: Sun, 10 Jun 2012 19:27:27 +0900
Message-ID: <CAAmzW4OuyCJVEHd823LvN3+uz=MN-4HGYyw8pbSUvhBN79wSjQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] slub: deactivate freelist of kmem_cache_cpu all at
 once in deactivate_slab()
From: JoonSoo Kim <js1304@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/9 Christoph Lameter <cl@linux.com>:
> On Sat, 9 Jun 2012, Joonsoo Kim wrote:
>
>> Current implementation of deactivate_slab() which deactivate
>> freelist of kmem_cache_cpu one by one is inefficient.
>> This patch changes it to deactivate freelist all at once.
>> But, there is no overall performance benefit,
>> because deactivate_slab() is invoked infrequently.
>
> Hmm, deactivate freelist can race with slab_free. Need to look at this in
> detail.

Implemented logic is nearly same as previous one.
I just merge first step of previous deactivate_slab() with second one.
In case of failure of cmpxchg_double_slab(), reloading page->freelist,
page->counters and recomputing inuse
ensure that race with slab_free() cannot be possible.
In case that we need a lock, try to get a lock before invoking
cmpxchg_double_slab(),
so race with slab_free cannot be occured too.

Above is my humble opinion, please give me some comments.
