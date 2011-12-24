Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab1LXTrY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 14:47:24 -0500
Received: from isrv.corpit.ru ([86.62.121.231]:47383 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782Ab1LXTrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 14:47:20 -0500
Message-ID: <4EF62C45.2080501@msgid.tls.msk.ru>
Date: Sat, 24 Dec 2011 23:47:17 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:5.0) Gecko/20110805 Icedove/5.0
MIME-Version: 1.0
To: Phil Miller <mille121@illinois.edu>
CC: Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <greg@kroah.com>,
        "stable@kernel.org" <stable@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: [REGRESSION,STABLE,BISECTED] Hang on resume from standby in 3.1.[56],
 3.2-rc*
References: <CAMDbWJG4u62qmBgxhaYZCuL+5897defC1cy5tNMd+M+9BhWS+g@mail.gmail.com> <CAMDbWJGjGo4BVpL+vwZJgBBJxradjzp2gvwVUqk-H9CvCL6XFg@mail.gmail.com> <d71755af705048a4868348343417a4c4@CITESHT4.ad.uillinois.edu> <CAMDbWJGzMKgRLjU3QznPJt1s-hizSyWqzGJv1bYZKvKDJzWYig@mail.gmail.com>
In-Reply-To: <CAMDbWJGzMKgRLjU3QznPJt1s-hizSyWqzGJv1bYZKvKDJzWYig@mail.gmail.com>
X-Enigmail-Version: 1.2.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.12.2011 20:51, Phil Miller wrote:
> On Sat, Dec 24, 2011 at 03:09, Michael Tokarev <mjt@tls.msk.ru> wrote:
>> On 24.12.2011 10:40, Phil Miller wrote:
>>> On Fri, Dec 23, 2011 at 11:31, Phil Miller <mille121@illinois.edu> wrote:
>>>> I've got a Dell Precision T1500 (lspci, dmidecode, and dmesg output at
>>>> http://charm.cs.uiuc.edu/~phil/linux-suspend-hang/ ) that I generally
>>>> suspend when I'm out of the house or asleep, and wake up when I want
>>>> to use it. Sadly, a recent change to the kernel has disrupted that
>>>> happy state of affairs. When I run the most recent stable or
[]
>> I  noticed that my host also stopped resuming with 3.1, and noted that
>> with 3.1.3 it works ok.  I'm now trying to revert this commit too, to
>> see if that's the problem.

Actually that wasn't the issue.  After several iterations (which took
some time) I found out that I can't reproduce the hangs which I were
able to trigger trivially just yesterday.  I can only guess these hangs
were due to some other software components (gnome, X stuff, whatever)
which happened to be upgraded today too, together with the kernel, and
the problem went away.  I booted into kernel with which the system
definitely had the issue at hand (3.1.3), but it resumes from suspend
(both s2ram and s2disk) without any issue whatsoever, I did several
resumes of each kind in a row, intermixed them together.

> I first noticed this using Debian unstable's packaged kernels, which
> call themselves 3.x.0, but actually get revved through the stable
> versions 3.x.y (I'll probably complain about that misnaming to them).
> The upgrade from 3.1.4 to 3.1.5 is where it broke, matching the
> bisection's results.

So it looks like not all systems suffer from this issue...

Please excuse me for the noize -- it really looked like the kernel
broke.

Thanks,

/mjt
