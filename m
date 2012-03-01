Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab2CAUZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:25:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:35337 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab2CAUZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:25:40 -0500
Message-ID: <4F4FDB3E.7000405@kernel.dk>
Date: Thu, 01 Mar 2012 21:25:34 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Muthu Kumar <muthu.lkml@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, martin.petersen@oracle.com
Subject: Re: [PATCH] Fix setting bio flags in drivers (sd_dif/floppy).
References: <CAFR8uef08sDCR=FM_v4EV0CLX9f4UuJezSTPFX6V7T-4b7xBVQ@mail.gmail.com> <20120229161215.81505738.akpm@linux-foundation.org> <CAFR8uedyn_dmE1NPk_H8_vb_ohYcScaG2whEa9=aOcSRWDvcxg@mail.gmail.com>
In-Reply-To: <CAFR8uedyn_dmE1NPk_H8_vb_ohYcScaG2whEa9=aOcSRWDvcxg@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-03-01 21:23, Muthu Kumar wrote:
>>>                       kunmap_atomic(sdt, KM_USER0);
>>>               }
>>>
>>> -             bio->bi_flags |= BIO_MAPPED_INTEGRITY;
>>> +             bio->bi_flags |= (1 << BIO_MAPPED_INTEGRITY);
>>>       }
>>>
>>>       return 0;
>>
>> urgh.  This isn't the first time.
>>
>> It's too easy for people to make this mistake.  I'm not sure what a
>> good fix would be - I don't think sparse can save us with __bitwise or
>> similar.
>>
>> The approach we took in buffer_head.h with BH_Foo and BUFFER_FNS
>> accessors worked pretty well.
>>
> 
> Does this look good? BTW, I used the non-atomic variants __set/__clear
> to match the behavior of current usage.
> If this looks good, I can send the proper patch as attachment (so no
> line wraps :)

Lets not wrap this in macros, it just makes the code harder to read.
Making the BIO_ flags a bit shift value was a mistake in hindsight, too
easy to get wrong.

If we're going to be changing everything anyway, it'd be better to have
__ variants if we really need the bit shifts, and the non __ variants be
the value. Similar to what is done for request flags.

-- 
Jens Axboe

