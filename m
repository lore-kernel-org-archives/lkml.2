Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030918Ab2ERD4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:56:42 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33097 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966450Ab2ERD4X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 23:56:23 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxtejaM8ecOw8VYk74OaXfGY7=LO3JSyz3rdHEv2r9goQ@mail.gmail.com>
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
	<1337292816-10839-9-git-send-email-hjl.tools@gmail.com>
	<4FB58EFD.7010302@zytor.com>
	<4FB5C050.9070805@kernel.org>
	<CAMe9rOrKq8Ait8wKudRF535J5c=dDTKekmUN_=HOs5BBLtsoGQ@mail.gmail.com>
	<CA+55aFxtejaM8ecOw8VYk74OaXfGY7=LO3JSyz3rdHEv2r9goQ@mail.gmail.com>
Date: Thu, 17 May 2012 20:56:22 -0700
Message-ID: <CAMe9rOqKz5MjENWDixpHgcNw9BiJDZWmXzN3NmmbLkbxQEKGqA@mail.gmail.com>
Subject: Re: [PATCH 08/10] Use __kernel_ulong_t in struct msqid64_ds
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 8:49 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, May 17, 2012 at 8:39 PM, H.J. Lu <hjl.tools@gmail.com> wrote:
>>
>> That will be wrong.   __BITS_PER_LONG defines # bits of long
>> as seen by kernel.  We don't use it in user space.
>
> Yes you do. Exactly in that structure that Peter points to. *Exactly*
> because that structure uses "long" instead of some fixed size. Which
> will be different in user mode than in kernel mode.
>
> And if user mode doesn't use these headers at all, then we should stop
> playing the insane games.
>
>                     Linus

We need kernel headers for constants used in system calls.  But I don't
mind if kernel stops exporting data structures to user space.


-- 
H.J.
