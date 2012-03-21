Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab2CUFOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 01:14:09 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42320 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab2CUFOG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 01:14:06 -0400
MIME-Version: 1.0
In-Reply-To: <4F6944D9.5090002@cn.fujitsu.com>
References: <1332238884-6237-1-git-send-email-laijs@cn.fujitsu.com>
	<1332238884-6237-7-git-send-email-laijs@cn.fujitsu.com>
	<20120320154619.GA5684@google.com>
	<4F6944D9.5090002@cn.fujitsu.com>
Date: Tue, 20 Mar 2012 22:14:05 -0700
X-Google-Sender-Auth: XuZ6_ONW3OMEl7WAGxkZcg3d3D0
Message-ID: <CAOS58YPydFUap4HjuRATxza6VZgyrXmQHVxR83G7GRJL50ZTRQ@mail.gmail.com>
Subject: Re: [RFC PATCH 6/6] workqueue: use kmalloc_align() instead of hacking
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Mar 20, 2012 at 8:02 PM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> Yes, I don't want to build a complex kmalloc_align(). But after I found
> that SLAB/SLUB's kmalloc-objects are natural/automatic aligned to
> a proper big power of two. I will do nothing if I introduce kmalloc_align()
> except just care the debugging.
>
> o       SLAB/SLUB's kmalloc-objects are natural/automatic aligned.
> o       70LOC in total, and about 90% are just renaming or wrapping.
>
> I think it is a worth trade-off, it give us convenience and we pay
> zero overhead(when runtime) and 70LOC(when coding, pay in a lump sum).
>
> And kmalloc_align() can be used in the following case:
> o       a type object need to be aligned with cache-line for it contains a frequent
>        update-part and a frequent read-part.
> o       The total number of these objects in a given type is not much, creating
>        a new slab cache for a given type will be overkill.
>
> This is a RFC patch and it seems mm gurus don't like it. I'm sorry I bother all of you.

Ooh, don't be sorry. My only concern is that it doesn't have any user
other than cwq allocation. If you can find other cases which can
benefit from it, it would be great.

Thanks.

-- 
tejun
