Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab0H0Xb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 19:31:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:39415 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710Ab0H0Xb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 19:31:27 -0400
Message-ID: <4C784B04.7060604@kernel.org>
Date: Sat, 28 Aug 2010 01:32:20 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Jeffrey Carlyle <jeff.carlyle@motorola.com>
CC: torvalds@osdl.org, linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        OLUSANYA SOYANNWO <olusanya.soyannwo@motorola.com>,
        Hu Tao <taohu@motorola.com>
Subject: Re: [PATCH] scatterlist: prevent invalid free when alloc fails
References: <AANLkTimoCn9uWQ1NTJAhRu7cq1MA+oo6E5p30zeXA3f1@mail.gmail.com>	<4C779111.8000803@kernel.org> <AANLkTinZLdSTVenJ=ShK9-f27eMQSyv=j6vYK+F3K96s@mail.gmail.com>
In-Reply-To: <AANLkTinZLdSTVenJ=ShK9-f27eMQSyv=j6vYK+F3K96s@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 27 Aug 2010 23:31:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/27/2010 09:45 PM, Jeffrey Carlyle wrote:
>>>               sg = alloc_fn(alloc_size, gfp_mask);
>>> -             if (unlikely(!sg))
>>> +             if (unlikely(!sg)) {
>>> +                     table->orig_nents = total_alloc;
>>> +                     /* mark the end of previous entry */
>>> +                     sg_mark_end(&prv[alloc_size - 1]);
>>
>> prv[alloc_size - 1] is already marked as end by sg_init_table() during
>> the previous iteration.  Also, prv can be NULL at this point.  AFAICS,
>> the only thing necessary would be "if (prv) table->nents++", no?
> 
> You are right about prv possibly being NULL here. Sorry for not
> catching that earlier; however, I don't think prv will be marked as an
> end in the previous iteration.

But we have sg_mark_end(&sgl[nents-1]) in sg_init_table().  I think
explicit end marking in __sg_alloc_table() is redundant.

Thanks.

-- 
tejun
