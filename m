Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab2FFMOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 08:14:39 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59401 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab2FFMOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 08:14:37 -0400
Message-id: <4FCF49A7.8040203@samsung.com>
Date: Wed, 06 Jun 2012 14:14:31 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
MIME-version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.comp.video.dri.devel,gmane.linux.drivers.video-input-infrastructure,gmane.linux.kernel
To: Andrew Morton <akpm@linux-foundation.org>
Cc: paul.gortmaker@windriver.com,
        =?UTF-8?B?J+uwleqyveuvvCc=?= <kyungmin.park@samsung.com>,
        amwang@redhat.com, dri-devel@lists.freedesktop.org,
        "'???/Mobile S/W Platform Lab.(???)/E3(??)/????'" 
	<inki.dae@samsung.com>,
        prashanth.g@samsung.com, Marek Szyprowski <m.szyprowski@samsung.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Clark <rob@ti.com>, Dave Airlie <airlied@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andy Whitcroft <apw@shadowen.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3] scatterlist: add sg_alloc_table_from_pages function
References: <4FA8EC69.8010805@samsung.com>
 <20120517165614.d5e6e4b6.akpm@linux-foundation.org>
 <4FBA4ACE.4080602@samsung.com>
 <20120522131059.415a881c.akpm@linux-foundation.org>
In-reply-to: <20120522131059.415a881c.akpm@linux-foundation.org>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 10:10 PM, Andrew Morton wrote:
> On Mon, 21 May 2012 16:01:50 +0200
> Tomasz Stanislawski <t.stanislaws@samsung.com> wrote:
> 
>>>> +int sg_alloc_table_from_pages(struct sg_table *sgt,
>>>> +	struct page **pages, unsigned int n_pages,
>>>> +	unsigned long offset, unsigned long size,
>>>> +	gfp_t gfp_mask)
>>>
>>> I guess a 32-bit n_pages is OK.  A 16TB IO seems enough ;)
>>>
>>
>> Do you think that 'unsigned long' for offset is too big?
>>
>> Ad n_pages. Assuming that Moore's law holds it will take
>> circa 25 years before the limit of 16 TB is reached :) for
>> high-end scatterlist operations.
>> Or I can change the type of n_pages to 'unsigned long' now at
>> no cost :).
> 
> By then it will be Someone Else's Problem ;)
> 

Ok. So let's keep to 'unsigned int n_pages'.

>>>> +{
>>>> +	unsigned int chunks;
>>>> +	unsigned int i;
>>>
>>> erk, please choose a different name for this.  When a C programmer sees
>>> "i", he very much assumes it has type "int".  Making it unsigned causes
>>> surprise.
>>>
>>> And don't rename it to "u"!  Let's give it a nice meaningful name.  pageno?
>>>
>>
>> The problem is that 'i' is  a natural name for a loop counter.
> 
> It's also the natural name for an integer.  If a C programmer sees "i",
> he thinks "int".  It's a Fortran thing ;)
> 
>> AFAIK, in the kernel code developers try to avoid Hungarian notation.
>> A name of a variable should reflect its purpose, not its type.
>> I can change the name of 'i' to 'pageno' and 'j' to 'pageno2' (?)
>> but I think it will make the code less reliable.
> 
> Well, one could do something radical such as using "p".
> 
> 

I can not change the type to 'int' due to 'signed vs unsigned' comparisons
in the loop condition.
What do you think about changing the names 'i' -> 'p' and 'j' -> 'q'?

Regards,
Tomasz Stanislawski

> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

