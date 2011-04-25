Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674Ab1DYRTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 13:19:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758203Ab1DYRTG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 13:19:06 -0400
MIME-Version: 1.0
In-Reply-To: <20110425190032.7904c95d@neptune.home>
References: <20110424202158.45578f31@neptune.home> <20110424235928.71af51e0@neptune.home>
 <20110425114429.266A.A69D9226@jp.fujitsu.com> <BANLkTinVQtLbmBknBZeY=7w7AOyQk61Pew@mail.gmail.com>
 <20110425111705.786ef0c5@neptune.home> <BANLkTi=d0UHrYXyTK0CBZYCSK-ax8+wuWQ@mail.gmail.com>
 <20110425180450.1ede0845@neptune.home> <BANLkTikSLA59tdgRL4B=cr5tvP2NbzZ=KA@mail.gmail.com>
 <20110425190032.7904c95d@neptune.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 25 Apr 2011 10:10:28 -0700
Message-ID: <BANLkTi=hQ=HcPLCdbb1pSi+xJByMTah-gw@mail.gmail.com>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning, regression?
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 10:00 AM, Bruno Prémont
<bonbons@linux-vserver.org> wrote:
>
> I hope tiny-rcu is not that broken... as it would mean driving any
> PREEMPT_NONE or PREEMPT_VOLUNTARY system out of memory when compiling
> packages (and probably also just unpacking larger tarballs or running
> things like du).

I'm sure that TINYRCU can be fixed if it really is the problem.

So I just want to make sure that we know what the root cause of your
problem is. It's quite possible that it _is_ a real leak of filp or
something, but before possibly wasting time trying to figure that out,
let's see if your config is to blame.

> And with system doing nothing (except monitoring itself) memory usage
> goes increasing all the time until it starves (well it seems to keep
> ~20M free, pushing processes it can to swap). Config is just being
> make oldconfig from working 2.6.38 kernel (answering default for new
> options)

How sure are you that the system really is idle? Quite frankly, the
constant growing doesn't really look idle to me.

> Attached graph matching numbers of previous mail. (dropping caches was at
> 17:55, system idle since then)

Nothing at all going on in 'ps' during that time? And what does
slabinfo say at that point now that kmemleak isn't dominating
everything else?

                        Linus
