Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab1K0UXS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 15:23:18 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50455 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab1K0UXQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 15:23:16 -0500
MIME-Version: 1.0
In-Reply-To: <CAOtrxKP-0TfJa8dS8_uW195WO13YCy-UyaZfweYD4Tv_1gAmKQ@mail.gmail.com>
References: <bug-41132-5003@https.bugzilla.kernel.org/> <201108160554.p7G5soeq002083@demeter2.kernel.org>
 <CAOtrxKP-0TfJa8dS8_uW195WO13YCy-UyaZfweYD4Tv_1gAmKQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 27 Nov 2011 12:22:54 -0800
X-Google-Sender-Auth: aLA5_KAC4Vpa2Gctp09twiwzUEc
Message-ID: <CA+55aFzh-ST1-Hu+Ny25X5DkEqktv3ZDFP2NDOWx6N+vFbTM8A@mail.gmail.com>
Subject: Re: [Bug 41132] [BISECTED][REGRESSION] Regression with the IRQ
 subsystem introduced in 2.6.39 (and present in the 3.x version)
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        drivers_pci@kernel-bugs.osdl.org,
        =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas, Ingo?

I haven't seen any response to this one, and while clearly commit
fa27271bc8d2 ("genirq: Fixup poll handling") was *supposed* to be a
no-op, it isn't.

The commit message says "Shorter version with the same
functionality.", but since it causes a regression, it clearly is not
with the same functionality at all. And I assume that Thomas doesn't
have a machine that actually ever triggers the spurious irq issue to
begin with, so it probably was never tested.

In short, it really sounds like this should just be reverted, since
the code clearly doesn't do what the commit message claims it does.

Comments?

              Linus

2011/11/22 Rogério Brito <rbrito@ime.usp.br>:
> Hi there.
>
> Now that, at least part of kernel.org is up, I would appreciate if
> more people could help with debugging something that I reported to
> bugzilla in july of this year, a regression (bisected) that led to a
> bad commit of Thomas in the 2.6.39 cycle as the first bad one.
>
> Bugzilla has more information on the issue, but as it seems to be
> down, I can, of course, summarize what I found. And, unfortunately,
> the problem still occurs with a recent pull of Linus tree up to
> v3.2-rc2-43-gaa1b052.
>
> Below is the link to my first message that was archived:
>
>> --- Comment #3 from Rogério Brito <rbrito@ime.usp.br>  2011-08-16 05:54:47 ---
>> Add note that this bug was first reported on 2011-07-04
>>
>>    https://lkml.org/lkml/2011/7/24/54
>>
>> As stated on that e-mail, I am willing to perform any tests to help fix this
>> bug. Just ask me and I will do my best to give you copious amounts of data.
>
>
> Thanks,
> Rogério Brito.
>
> --
> Rogério Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 4096R/BCFCAAAA
> http://rb.doesntexist.org : Packages for LaTeX : algorithms.berlios.de
> DebianQA: http://qa.debian.org/developer.php?login=rbrito%40ime.usp.br
>
