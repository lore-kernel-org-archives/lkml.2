Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab2HOQfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 12:35:43 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57964 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab2HOQfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 12:35:42 -0400
MIME-Version: 1.0
In-Reply-To: <000001392af5ab4e-41dbbbe4-5808-484b-900a-6f4eba102376-000000@email.amazonses.com>
References: <1345045084-7292-1-git-send-email-js1304@gmail.com>
	<000001392af5ab4e-41dbbbe4-5808-484b-900a-6f4eba102376-000000@email.amazonses.com>
Date: Thu, 16 Aug 2012 01:35:41 +0900
Message-ID: <CAAmzW4M9WMnxVKpR00SqufHadY-=i0Jgf8Ktydrw5YXK8VwJ7A@mail.gmail.com>
Subject: Re: [PATCH] slub: try to get cpu partial slab even if we get enough
 objects for cpu freelist
From: JoonSoo Kim <js1304@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/16 Christoph Lameter <cl@linux.com>:
> On Thu, 16 Aug 2012, Joonsoo Kim wrote:
>
>> s->cpu_partial determine the maximum number of objects kept
>> in the per cpu partial lists of a processor. Currently, it is used for
>> not only per cpu partial list but also cpu freelist. Therefore
>> get_partial_node() doesn't work properly according to our first intention.
>
> The "cpu freelist" in slub is the number of free objects in a specific
> page. There is nothing that s->cpu_partial can do about that.
>
> Maybe I do not understand you correctly. Could you explain this in some
> more detail?

I assume that cpu slab and cpu partial slab are not same thing.

In my definition,
cpu slab is in c->page,
cpu partial slab is in c->partial

When we have no free objects in cpu slab and cpu partial slab, we try
to get slab via get_partial_node().
In that function, we call acquire_slab(). Then we hit "!object" case
(for cpu slab).
In that case, we test available with s->cpu_partial.

I think that s->cpu_partial is for cpu partial slab, not cpu slab.
So this test is not proper.
This patch is for correcting this.

Thanks!
