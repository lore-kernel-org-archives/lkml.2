Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360Ab1DYTZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 15:25:38 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64405 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab1DYTZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 15:25:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=xwR3zGfIoa4Emiy8w4UqKxwT2S4a25zPXzcoZL4PQzeQyVKvZj1YBqb7LoTlVqV/V6
         0C/GgUAk50hhEIyU4UVnluUiA41TT56b+MG1YSkEemVXZMKu4KsMl3iDIFGycPqY4loP
         gsjZkjK4HIUku0nG0Yxv6Pjh9KePcnTKMLc60=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1104251407090.9646@router.home>
References: <1303753608-19248-1-git-send-email-penberg@kernel.org>
	<1303753608-19248-2-git-send-email-penberg@kernel.org>
	<alpine.DEB.2.00.1104251407090.9646@router.home>
Date: Mon, 25 Apr 2011 22:25:36 +0300
X-Google-Sender-Auth: gqONVL3FjRA5Ha85zhwC3YHtezc
Message-ID: <BANLkTinMC9HTjTKtGeJjG-6Gnz2w4FZvyw@mail.gmail.com>
Subject: Re: [RFC/PATCH 2/2] slub: Don't share struct kmem_cache for shared caches
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Apr 2011, Pekka Enberg wrote:
>> This patch changes the slab cache sharing in SLUB to only share 'struct
>> kmem_cpu_cache' which contains the actual list of slabs and object freelists.
>> We no longer share 'struct kmem_cache' between merged caches so /proc/slabinfo
>> statistics work as expected:

On Mon, Apr 25, 2011 at 10:09 PM, Christoph Lameter <cl@linux.com> wrote:
> I am a bit confused. Struct kmem_cache contains per slab
> allocation information and all pages have pointers to struct kmem_cache.
>
> So we have pages now on the kmem_cache_cpu list with varying kmem_cache
> pointers? How do we figure out which cache a page belongs to? It seems
> that a page from one cache can be freed to the freelists of another.

We share the freelist so it goes to the same freelist. However, I
completely forgot about page to struct kmem_cache mapping so stats
won't work properly.

On Mon, Apr 25, 2011 at 10:09 PM, Christoph Lameter <cl@linux.com> wrote:
> Does this even run right with the debugging enabled?

It boots OK to minimal userspace under KVM with slub_debug. But no, I
didn't test it properly yet.

                        Pekka
