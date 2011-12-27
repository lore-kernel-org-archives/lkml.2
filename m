Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab1L0SMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 13:12:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59168 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab1L0SMG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 13:12:06 -0500
MIME-Version: 1.0
In-Reply-To: <CAGHUO13PjU2tMj=oge3J5gYtMEiNMeCYas7PuV8djuSiOyXoFQ@mail.gmail.com>
References: <CAMDbWJG4u62qmBgxhaYZCuL+5897defC1cy5tNMd+M+9BhWS+g@mail.gmail.com>
	<CAMDbWJGjGo4BVpL+vwZJgBBJxradjzp2gvwVUqk-H9CvCL6XFg@mail.gmail.com>
	<d71755af705048a4868348343417a4c4@CITESHT4.ad.uillinois.edu>
	<CAMDbWJGzMKgRLjU3QznPJt1s-hizSyWqzGJv1bYZKvKDJzWYig@mail.gmail.com>
	<4EF62C45.2080501@msgid.tls.msk.ru>
	<CAGHUO13PjU2tMj=oge3J5gYtMEiNMeCYas7PuV8djuSiOyXoFQ@mail.gmail.com>
Date: Tue, 27 Dec 2011 10:12:03 -0800
Message-ID: <CABeCy1YVLV7Ff0Oyo5ayCbRjMfX79xhFAEh-x+PWHBwLFzw1mQ@mail.gmail.com>
Subject: Re: [REGRESSION,STABLE,BISECTED] Hang on resume from standby in
 3.1.[56], 3.2-rc*
From: Venki Pallipadi <venki@google.com>
To: Joseph Salisbury <josephtsalisbury@gmail.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Phil Miller <mille121@illinois.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <greg@kroah.com>,
        "stable@kernel.org" <stable@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 24, 2011 at 1:12 PM, Joseph Salisbury
<josephtsalisbury@gmail.com> wrote:
>
>
> On Sat, Dec 24, 2011 at 2:47 PM, Michael Tokarev <mjt@tls.msk.ru> wrote:
>>
>> On 24.12.2011 20:51, Phil Miller wrote:
>> > On Sat, Dec 24, 2011 at 03:09, Michael Tokarev <mjt@tls.msk.ru> wrote:
>> >> On 24.12.2011 10:40, Phil Miller wrote:
>> >>> On Fri, Dec 23, 2011 at 11:31, Phil Miller <mille121@illinois.edu>
>> >>> wrote:
>> >>>> I've got a Dell Precision T1500 (lspci, dmidecode, and dmesg output
>> >>>> at
>> >>>> http://charm.cs.uiuc.edu/~phil/linux-suspend-hang/ ) that I generally
>> >>>> suspend when I'm out of the house or asleep, and wake up when I want
>> >>>> to use it. Sadly, a recent change to the kernel has disrupted that
>> >>>> happy state of affairs. When I run the most recent stable or
>> []
>> >> I  noticed that my host also stopped resuming with 3.1, and noted that
>> >> with 3.1.3 it works ok.  I'm now trying to revert this commit too, to
>> >> see if that's the problem.
>>
>> Actually that wasn't the issue.  After several iterations (which took
>> some time) I found out that I can't reproduce the hangs which I were
>> able to trigger trivially just yesterday.  I can only guess these hangs
>> were due to some other software components (gnome, X stuff, whatever)
>> which happened to be upgraded today too, together with the kernel, and
>> the problem went away.  I booted into kernel with which the system
>> definitely had the issue at hand (3.1.3), but it resumes from suspend
>> (both s2ram and s2disk) without any issue whatsoever, I did several
>> resumes of each kind in a row, intermixed them together.
>>
>> > I first noticed this using Debian unstable's packaged kernels, which
>> > call themselves 3.x.0, but actually get revved through the stable
>> > versions 3.x.y (I'll probably complain about that misnaming to them).
>> > The upgrade from 3.1.4 to 3.1.5 is where it broke, matching the
>> > bisection's results.
>>
>> So it looks like not all systems suffer from this issue...
>>
>> Please excuse me for the noize -- it really looked like the kernel
>> broke.
>>
>> Thanks,
>>
>> /mjt
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
> This issue also happens in the 3.0 kernel.  A bisect and revert was done for
> a bug report[1].  Testing indicated the same commit caused the
> suspend/resume issue.
>

Both the reports here from Phil and Joe are with systems hav HPET MSI support
--
[    1.010213] HPET: 8 timers in total, 5 timers will be used for per-cpu timer
[    1.010221] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 40, 41, 42, 43, 44, 0
[    1.010226] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.014637] hpet: hpet2 irq 40 for MSI
[    1.014771] hpet: hpet3 irq 41 for MSI
[    1.018748] hpet: hpet4 irq 42 for MSI
[    1.022810] hpet: hpet5 irq 43 for MSI
[    1.026712] hpet: hpet6 irq 44 for MSI
--

The ordering issue addressed in
7c1e76897492d92b6a1c2d6892494d39ded9680c was found with HPET MSI.
So, it seems like change de28f25e8244c7353abed8de0c7792f5f883588c
opened up that ordering problem again.

Thomas: Is de28f25e8244c7353abed8de0c7792f5f883588c for a specific bug
or regression on some platform?

Thanks,
Venki

>
> Thanks,
>
> Joe
>
> [1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/904569
