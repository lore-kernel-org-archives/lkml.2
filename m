Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab1FWE2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 00:28:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750940Ab1FWE2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 00:28:46 -0400
MIME-Version: 1.0
In-Reply-To: <m2boxp39zz.fsf@firstfloor.org>
References: <BANLkTimiVpKavmKY=rsJP34dMQSq__Xn7g@mail.gmail.com> <m2boxp39zz.fsf@firstfloor.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 22 Jun 2011 21:28:24 -0700
Message-ID: <BANLkTiksHMkPr-ZXJ6iCpUCupmpapU5D2Q@mail.gmail.com>
Subject: Re: Linux 3.0-rc4
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 1:08 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
>
>> and the
>> conversion from spinlocks to mutexes for the anon_vma locking ended up
>> causing a scalability issue that required fixing.
>
> FWIW it's still ~16% slower. Does that count as fixed?

Well, so far I haven't really seen any suggestions on how to improve
it much further.

3.0 will still be noticeably faster than 2.6.39 due to the other
changes made (ie the read-ahead), so yes, the regression itself is
fixed.

But performance on that particular benchmark with that particular
machine is clearly not optimal, in that there are known setups that
would be faster still.

Of course, the reason for the mutex conversion was _other_ loads,
where the spinlocks had bad behavior. So it's a balancing act. And I
suspect we've reached a reasonable point in that balancing, yes.

                  Linus
