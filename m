Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab2ASJRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 04:17:20 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:15520 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab2ASJRP convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Thu, 19 Jan 2012 04:17:15 -0500
Message-Id: <4F17EDE9020000780006D97A@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 19 Jan 2012 09:18:17 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <mingo@elte.hu>, "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        <tglx@linutronix.de>, <luca@luca-barbieri.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ix86: atomic64 assembly improvements
References: <4F16E41B020000780006D7A5@nat28.tlf.novell.com>
 <4F16F505.8040809@zytor.com>
 <4F170679020000780006D85B@nat28.tlf.novell.com> <4F1705A8.301@zytor.com>
In-Reply-To: <4F1705A8.301@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 18.01.12 at 18:47, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 01/18/2012 08:50 AM, Jan Beulich wrote:
>>>
>>> It's atomic in the same way a MOV is atomic.
>>
>> Then please point me to where this is documented.
>>
>> As I understand it, there is nothing keeping the CPU (or something
>> down the bus) from executing the unlocked version as two 32-bit
>> reads followed by two 32-bit writes.
>>
>>> The CPU could, in fact, execute the locked version at all if the
>>> unlocked version didn't behave like that.
>>
>> Assuming you meant "could not", that's not true: As long as the
>> external world has a way to know that both items are locked (think
>> of the old bus lock mechanism when there were no caches yet),
>> it can very well do so.
>>
>> I do not question that in practice all CPUs behave as described,
>> but without an architectural guarantee (and with the code in
>> question not being used in hot paths afaik) I see no reason why
>> it should depend on undefined behavior.
>>
> 
> Sorry, Jan, if you want to play the documentation lawyer game then there 
> is very little that will get done.  The code is increasingly being used 
> in warm/hot paths and that's actually fair, so I'd like to avoid 
> crapping it up.
> 
> There are, to my knowledge, only three companies which have brought 
> SMP-capable x86 processors to market: Intel, AMD, and VIA and the above 
> holds for them.  A new vendor realistically can't bring a new processor 
> to market which violates a constraint that the existing processor 
> vendors have preserved.
> 
> It is somewhat implied in the SDM section 8.1.1 of volume 3A, but as 
> with many other things it's not written out specifically... I suspect 
> largely because the question hasn't been raised before.

But the code is supposed to be correct even when caches are disabled
(in which case LOCK# will continue to be used even on modern CPUs),
and this case clearly isn't covered by the current implementation. It
may be a good idea to adjust the patch description accordingly, but I
see no reason to change the patch itself.

Jan

