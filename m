Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561Ab0E1LMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 07:12:21 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:42732 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755971Ab0E1LMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 07:12:20 -0400
Message-ID: <4BFFA4EF.4050401@euromail.se>
Date: Fri, 28 May 2010 13:11:43 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Stefani Seibold <stefani@seibold.net>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       andi@firstfloor.org, gregkh@suse.de, alan@lxorguk.ukuu.org.uk,
       tytso@mit.edu, iws@ovro.caltech.edu
Subject: Re: really generic, type save and type definable.
References: <1273654167-31067-1-git-send-email-stefani@seibold.net>	 <4BFF7418.8020607@euromail.se> <1275042747.23895.5.camel@wall-e.seibold.net>
In-Reply-To: <1275042747.23895.5.camel@wall-e.seibold.net>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OHxTm-0004Nb-4o.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1OHxTm-0004Nb-4o b9c72917c035c38f2b283f0354f1c94e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefani Seibold wrote:
> Am Freitag, den 28.05.2010, 09:43 +0200 schrieb Henrik Rydberg:
>> stefani@seibold.net wrote:
>> [...]
>>> The main goal was to provide an API which is very intuitive, save and easy
>>> to use. So linux will get now a powerful fifo API which provides all what 
>>> a developer needs. This will save in the future a lot of kernel space, since
>>> there is no need to write an own implementation. Most of the device driver 
>>> developers need a fifo, and also deep kernel development will gain benefit 
>>> from this API.
>> The meaning of the term "multiple readers" referred to in the header is somewhat
>> ambiguous. It could in principle refer to concurrent reading of the same
>> position, or concurrent reading from different positions. Imaginably, those
>> cases also have different locking behavior.
>>
>> What happens if two fifos are initialized with the same memory buffer?
>>
> 
> That would be a big nonsense! Tell me a real use case for such kind of
> request...

I am referring to a buffer where one thread writes data to the queue, and
several other threads read the _same_ data from the queue. Such a queue would
most likely have separate storage for the (buffer, head) on one hand, and the
tails on the other hand. I was interested in whether anyone had put any thought
into it, in particular with regard to a possible lock-less implementation.

I understand that it is not a good idea to use the same memory buffer in your
kfifo implementation, I was merely suggesting the documentation say so as well.

> 
>> What about one-to-many and many-to-one cases? The input system and the logging
>> facilities could serve as examples where such buffers would be useful.
>>
> 
> There is no ne-to-many and many-to-one cases since the API will handle
> this. You can not read more data then fit in the fifo, also u can not
> write more data the fifo can handle.

I am not sure is this comment means "the API will not allow it", or if we simply
got off on the wrong foot. If there is no interest in a one-to-many buffer, all
is fine. Otherwise, this thread seems like an appropriate place for such a
discussion, does it not?

Henrik
