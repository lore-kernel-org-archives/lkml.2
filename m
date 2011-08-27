Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab1H0BqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 21:46:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754866Ab1H0BqH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 21:46:07 -0400
MIME-Version: 1.0
In-Reply-To: <4E5849EC.4060406@zytor.com>
References: <4E582577.2060805@zytor.com> <CA+55aFzkpt48EPdVrs3aoALXnqAwqHfUCeZOpvf874O8Y8+POQ@mail.gmail.com>
 <4E582EAA.1040108@zytor.com> <CA+55aFxdRMxWLh1B_8v29qFafM425uH7kbYRfqoPe3TpVwOx-w@mail.gmail.com>
 <CA+55aFyVmA_26LYaJH8dnFhwo7LWM6Ck7qFxCQvnROEHSuV_aA@mail.gmail.com>
 <4E58401A.2030002@zytor.com> <CA+55aFxtM0MbqBYQoTxfPOj8jVqj1Rc=s3YjDhg5wXUb3Y5BPQ@mail.gmail.com>
 <4E5849EC.4060406@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Aug 2011 18:45:45 -0700
Message-ID: <CA+55aFwNpvMYF8=xmSOxmt5rj=wNFaGWJkNZQXw2fn4fW0rXHw@mail.gmail.com>
Subject: Re: RFD: x32 ABI system call numbers
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 6:35 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Y2038 is certainly the single biggest issue here, and I fully admit to
> not having a good answer on that one.  Note that applies to every single
> 32-bit ABI in the Linux kernel, including asm-generic which is used by
> all brand new architectures.

So I've had journalists ask me about it, and I've always said that by
the time 2038 rolls around, we'll all be using 64-bit CPU's.

Which I think is a reasonable answer.

But if those 64-bit CPU's are then running some ULP32 "fast mode",
then that answer goes out the window. And I really think it's
fundamentally wrong to have "off_t" and "time_t" be 32-bit in this day
and age.  I'd hate to introduce a new mode like that. It just makes me
go "Eww".

                         Linus
