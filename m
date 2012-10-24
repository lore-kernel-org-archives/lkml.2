Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965209Ab2JXSCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 14:02:39 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61200 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161038Ab2JXSCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 14:02:32 -0400
MIME-Version: 1.0
In-Reply-To: <1351087158-8524-2-git-send-email-glommer@parallels.com>
References: <1351087158-8524-1-git-send-email-glommer@parallels.com>
	<1351087158-8524-2-git-send-email-glommer@parallels.com>
Date: Wed, 24 Oct 2012 21:02:32 +0300
X-Google-Sender-Auth: 66rjzjENWtNjNbKzbuggKDuBDWQ
Message-ID: <CAOJsxLHxo7zJk=aWrjmuaYsEkaChTCgXowtHxtuiabaOP3W3-Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] kmem_cache: include allocators code directly into slab_common
From: Pekka Enberg <penberg@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        Christoph Lameter <cl@linux.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 4:59 PM, Glauber Costa <glommer@parallels.com> wrote:
> While the goal of slab_common.c is to have a common place for all
> allocators, we face two different goals that are in opposition to each
> other:
>
> 1) Have the different layouts be the business of each allocator, in
> their .c
> 2) inline as much as we can for fast paths
>
> Because of that, we either have to move all the entry points to the
> mm/slab.h and rely heavily on the pre-processor, or include all .c files
> in here.
>
> The pre-processor solution has the disadvantage that some quite
> non-trivial code gets even more non-trivial, and we end up leaving for
> readers a non-pleasant indirection.
>
> To keep this sane, we'll include the allocators .c files in here.  Which
> means we will be able to inline any code they produced, but never the
> other way around!
>
> Doing this produced a name clash. This was resolved in this patch
> itself.
>
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Joonsoo Kim <js1304@gmail.com>
> CC: David Rientjes <rientjes@google.com>
> CC: Pekka Enberg <penberg@kernel.org>
> CC: Christoph Lameter <cl@linux.com>

So I hate this patch with a passion. We don't have any fastpaths in
mm/slab_common.c nor should we. Those should be allocator specific.

                         Pekka
