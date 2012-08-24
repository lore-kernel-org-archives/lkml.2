Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965028Ab2HXQk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 12:40:26 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57542 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964937Ab2HXQkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 12:40:23 -0400
MIME-Version: 1.0
In-Reply-To: <000001395978f794-7569c405-1955-4e20-ad74-6e60ee4efcdc-000000@email.amazonses.com>
References: <1345824303-30292-1-git-send-email-js1304@gmail.com>
	<1345824303-30292-2-git-send-email-js1304@gmail.com>
	<00000139596a800b-875d7863-23ac-44a5-8710-ea357f3df8a8-000000@email.amazonses.com>
	<CAAmzW4ORnSLMdhVPmYPpeEJ=P1rrpz1LOibOYWQJgOYQxmDhuA@mail.gmail.com>
	<000001395978f794-7569c405-1955-4e20-ad74-6e60ee4efcdc-000000@email.amazonses.com>
Date: Sat, 25 Aug 2012 01:40:22 +0900
Message-ID: <CAAmzW4MjPGC+e4FuMO2M+OWLNG3M+FKhX7Qaz+DtedfKLF_S0Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] slub: correct the calculation of the number of cpu
 objects in get_partial_node
From: JoonSoo Kim <js1304@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/25 Christoph Lameter <cl@linux.com>:
> On Sat, 25 Aug 2012, JoonSoo Kim wrote:
>
>> But, when using "cpu_partial_objects", I have a coding style problem.
>>
>>                 if (kmem_cache_debug(s)
>>                         || cpu_slab_objects + cpu_partial_objects
>>                                                 > s->max_cpu_object / 2)
>>
>> Do you have any good idea?
>
> Not sure what the problem is? The line wrap?

Yes! The line wrap.


                if (kmem_cache_debug(s)
                || cpu_slab_objects + cpu_partial_objects >
s->max_cpu_object / 2)
                        break;

Above example use 82 columns... The line wrapping problem.

                if (kmem_cache_debug(s) ||
                cpu_slab_objects + cpu_partial_objects > s->max_cpu_object / 2)
                        break;

This one use 79 columns, but somehow ugly
because second line start at same column of above line.
Is it okay?


                if (kmem_cache_debug(s)
                        || cpu_slab_objects + cpu_partial_objects
                                                > s->max_cpu_object / 2)
                        break;

Is it the best?
It use 72 columns.
Let me know what is the best method for this situation.

Thanks!
