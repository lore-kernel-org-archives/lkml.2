Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab2ARQuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 11:50:55 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:49279 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab2ARQuy convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 18 Jan 2012 11:50:54 -0500
Message-Id: <4F170679020000780006D85B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 18 Jan 2012 16:50:49 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <mingo@elte.hu>, "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        <tglx@linutronix.de>, <luca@luca-barbieri.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ix86: atomic64 assembly improvements
References: <4F16E41B020000780006D7A5@nat28.tlf.novell.com>
 <4F16F505.8040809@zytor.com>
In-Reply-To: <4F16F505.8040809@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 18.01.12 at 17:36, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 01/18/2012 06:24 AM, Jan Beulich wrote:
>> The cmpxchg8b variants of "set" and "xchg" are really identical, and
>> hence don't need to be repeated: %ebx and %ecx don't need to be copied
>> into %eax and %edx respectively (this is only necessary when desiring
>> to only read the stored value), and the LOCK prefix should also be used
>> in "set" (other than the comment that is now being removed was saying,
>> there is - to my knowledge - no *architectural* guarantee that aligned
>> 64-bit writes would always be carried out atomically).
> 
> EWHAT?
> 
> It's atomic in the same way a MOV is atomic.

Then please point me to where this is documented.

As I understand it, there is nothing keeping the CPU (or something
down the bus) from executing the unlocked version as two 32-bit
reads followed by two 32-bit writes.

> The CPU could, in fact, execute the locked version at all if the
> unlocked version didn't behave like that.

Assuming you meant "could not", that's not true: As long as the
external world has a way to know that both items are locked (think
of the old bus lock mechanism when there were no caches yet),
it can very well do so.

I do not question that in practice all CPUs behave as described,
but without an architectural guarantee (and with the code in
question not being used in hot paths afaik) I see no reason why
it should depend on undefined behavior.

Jan

> Unless you have a specific instance where you think this might be
> violated, please let me know.
> 
> 	-hpa
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.



