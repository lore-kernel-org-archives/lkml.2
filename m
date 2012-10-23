Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab2JWOPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 10:15:31 -0400
Received: from mx2.parallels.com ([64.131.90.16]:53604 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531Ab2JWOPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 10:15:30 -0400
Message-ID: <5086A678.7010403@parallels.com>
Date: Tue, 23 Oct 2012 18:15:20 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: JoonSoo Kim <js1304@gmail.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 2/2] slab: move kmem_cache_free to common code
References: <1350914737-4097-1-git-send-email-glommer@parallels.com> <1350914737-4097-3-git-send-email-glommer@parallels.com> <0000013a88eff593-50da3bb8-3294-41db-9c32-4e890ef6940a-000000@email.amazonses.com> <508561E0.5000406@parallels.com> <CAAmzW4PJkDbLJBKZ1zPNDw+dHPcgzX_25tMw3rWoX0ybpXACSQ@mail.gmail.com> <50865024.60309@parallels.com> <0000013a8df775ea-2411bbc8-8025-4514-8b58-ef007d11beef-000000@email.amazonses.com>
In-Reply-To: <0000013a8df775ea-2411bbc8-8025-4514-8b58-ef007d11beef-000000@email.amazonses.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 06:12 PM, Christoph Lameter wrote:
> On Tue, 23 Oct 2012, Glauber Costa wrote:
> 
>> I do agree, but since freeing is ultimately dependent on the allocator
>> layout, I don't see a clean way of doing this without dropping tears of
>> sorrow around. The calls in slub/slab/slob would have to be somehow
>> inlined. Hum... maybe it is possible to do it from
>> include/linux/sl*b_def.h...
>>
>> Let me give it a try and see what I can come up with.
> 
> The best solution would be something that would have a consolidated
> kmem_cache_free() in include/linux/slab.h.
> 

I don't know what exactly do you have in mind, but since the cache
layouts are very different, this is quite hard to do without incurring
without function calls anyway.

Do take a look at what I sent in response to that, and tell me what do
you think.

