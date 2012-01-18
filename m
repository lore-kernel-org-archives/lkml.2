Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab2ARRr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 12:47:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60082 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932378Ab2ARRrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 12:47:43 -0500
Message-ID: <4F1705A8.301@zytor.com>
Date: Wed, 18 Jan 2012 09:47:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: mingo@elte.hu, "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        tglx@linutronix.de, luca@luca-barbieri.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ix86: atomic64 assembly improvements
References: <4F16E41B020000780006D7A5@nat28.tlf.novell.com> <4F16F505.8040809@zytor.com> <4F170679020000780006D85B@nat28.tlf.novell.com>
In-Reply-To: <4F170679020000780006D85B@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2012 08:50 AM, Jan Beulich wrote:
>>
>> It's atomic in the same way a MOV is atomic.
>
> Then please point me to where this is documented.
>
> As I understand it, there is nothing keeping the CPU (or something
> down the bus) from executing the unlocked version as two 32-bit
> reads followed by two 32-bit writes.
>
>> The CPU could, in fact, execute the locked version at all if the
>> unlocked version didn't behave like that.
>
> Assuming you meant "could not", that's not true: As long as the
> external world has a way to know that both items are locked (think
> of the old bus lock mechanism when there were no caches yet),
> it can very well do so.
>
> I do not question that in practice all CPUs behave as described,
> but without an architectural guarantee (and with the code in
> question not being used in hot paths afaik) I see no reason why
> it should depend on undefined behavior.
>

Sorry, Jan, if you want to play the documentation lawyer game then there 
is very little that will get done.  The code is increasingly being used 
in warm/hot paths and that's actually fair, so I'd like to avoid 
crapping it up.

There are, to my knowledge, only three companies which have brought 
SMP-capable x86 processors to market: Intel, AMD, and VIA and the above 
holds for them.  A new vendor realistically can't bring a new processor 
to market which violates a constraint that the existing processor 
vendors have preserved.

It is somewhat implied in the SDM section 8.1.1 of volume 3A, but as 
with many other things it's not written out specifically... I suspect 
largely because the question hasn't been raised before.

	-hpa
