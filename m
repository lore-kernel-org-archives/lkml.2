Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030820Ab2ERD4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:56:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40121 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966450Ab2ERD4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 23:56:13 -0400
Message-ID: <4FB5C843.9070002@kernel.org>
Date: Thu, 17 May 2012 20:55:47 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H.J. Lu" <hjl.tools@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        Paul Mundt <lethal@linux-sh.org>, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 08/10] Use __kernel_ulong_t in struct msqid64_ds
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com> <1337292816-10839-9-git-send-email-hjl.tools@gmail.com> <4FB58EFD.7010302@zytor.com> <4FB5C050.9070805@kernel.org> <CAMe9rOrKq8Ait8wKudRF535J5c=dDTKekmUN_=HOs5BBLtsoGQ@mail.gmail.com> <CA+55aFxtejaM8ecOw8VYk74OaXfGY7=LO3JSyz3rdHEv2r9goQ@mail.gmail.com>
In-Reply-To: <CA+55aFxtejaM8ecOw8VYk74OaXfGY7=LO3JSyz3rdHEv2r9goQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 08:49 PM, Linus Torvalds wrote:
> On Thu, May 17, 2012 at 8:39 PM, H.J. Lu <hjl.tools@gmail.com> wrote:
>>
>> That will be wrong.   __BITS_PER_LONG defines # bits of long
>> as seen by kernel.  We don't use it in user space.
> 
> Yes you do. Exactly in that structure that Peter points to. *Exactly*
> because that structure uses "long" instead of some fixed size. Which
> will be different in user mode than in kernel mode.
> 
> And if user mode doesn't use these headers at all, then we should stop
> playing the insane games.
> 

User mode can, and should, be able to use the exported headers.  David
Howells have been doing even more work to distill out the actual
exported ABIs from the kernel and remove remaining chaff.

That being said it seems kind of loopy to expect something called
__BITS_PER_LONG to be anything other than (CHAR_BIT*sizeof(long)),
especially since one of the main uses of it seems to be sizing
bitvectors (which has its own issues on bigendian machines because I
think we do littleendian bit numbering even on bigendian iron).

	-hpa
