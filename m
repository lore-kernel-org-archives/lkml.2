Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab2BIMm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 07:42:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:41224 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab2BIMmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 07:42:55 -0500
Message-ID: <4F33BF02.7060906@kernel.dk>
Date: Thu, 09 Feb 2012 13:41:38 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: integer overflows in kernel/relay.c
References: <20120207141155.GA16184@elgon.mountain> <4F323388.7040902@kernel.dk> <20120208142513.4db2493a.akpm@linux-foundation.org>
In-Reply-To: <20120208142513.4db2493a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2012 11:25 PM, Andrew Morton wrote:
> On Wed, 08 Feb 2012 09:34:16 +0100
> Jens Axboe <axboe@kernel.dk> wrote:
> 
>> On 02/07/2012 03:11 PM, Dan Carpenter wrote:
>>> My static checker is warning about integer overflows in kernel/relay.c
>>>
>>> relay_create_buf()
>>>    170  
>>>    171          buf->padding = kmalloc(chan->n_subbufs * sizeof(size_t *), GFP_KERNEL);
>>>                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>> This can only overflow on 32bit systems.
>>
>> Correct
> 
> This is a relatively common problem.  Converting a kzalloc() call to
> kcalloc() fixes it.  But we do not have a non-zeroing version of
> kcalloc().
> 
> Please, someone complete this patch and send it to me!
> 
> 
> --- a/include/linux/slab.h~a
> +++ a/include/linux/slab.h
> @@ -240,11 +240,16 @@ size_t ksize(const void *);
>   * for general use, and so are not documented here. For a full list of
>   * potential flags, always refer to linux/gfp.h.
>   */
> -static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
> +static inline void *wtf_do_i_call_this(size_t n, size_t size, gfp_t flags)

kzcalloc()? Either that, or long_and_verbose().

-- 
Jens Axboe

