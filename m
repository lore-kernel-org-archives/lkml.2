Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953Ab2BINUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 08:20:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60335 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab2BINUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 08:20:50 -0500
Message-ID: <4F33C7D7.1060801@kernel.dk>
Date: Thu, 09 Feb 2012 14:19:19 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Xi Wang <xi.wang@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH RFC] slab: introduce knalloc/kxnalloc
References: <20120207141155.GA16184@elgon.mountain> <4F323388.7040902@kernel.dk> <20120208142513.4db2493a.akpm@linux-foundation.org> <4F33BF05.208@gmail.com> <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com>
In-Reply-To: <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2012 02:05 PM, Pekka Enberg wrote:
> On Thu, Feb 9, 2012 at 2:41 PM, Xi Wang <xi.wang@gmail.com> wrote:
>> This patch introduces knalloc/kxnalloc wrappers that perform integer
>> overflow checks without zeroing the memory.
>>
>> knalloc(n, size, flags) is the non-zeroing version of kcalloc(),
>> which allocates n * size bytes.
>>
>> kxnalloc(xsize, n, size, flags) allocates xsize + n * size bytes.
>> It is useful to allocate a structure ending with a zero-length array,
>> which is a commonly used pattern.  For example, in posix_acl_alloc()
>> to allocate a posix_acl object one could call
>>
>>    kxnalloc(sizeof(struct posix_acl),
>>             count, sizeof(struct posix_acl_entry), flags);
>>
>> to avoid overflowing the allocation size.
>>
>> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
>> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> 
> Are there really enough potential users to justify adding both?

Agree, lets not overdesign. kmalloc_array() sounds good to me, fwiw.

-- 
Jens Axboe

