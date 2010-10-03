Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab0JCKVq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 06:21:46 -0400
Received: from ist.d-labs.de ([213.239.218.44]:43892 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab0JCKVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 06:21:45 -0400
Date: Sun, 3 Oct 2010 12:21:43 +0200
From: Florian Mickler <florian@mickler.org>
To: tmhikaru@gmail.com
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: PROBLEM: Unusually high load average when idle in 2.6.35,
 2.6.35.1 and later
Message-ID: <20101003122143.69cd3b9a@schatten.dmk.lab>
In-Reply-To: <20101003030254.GA4901@roll>
References: <20101001035321.GA2360@roll>
	<20101001094814.GA5029@roll>
	<20101003030254.GA4901@roll>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Oct 2010 23:02:54 -0400
tmhikaru@gmail.com wrote:

> 	These final tests I think conclusively prove that I've been on a
> wild goose chase. The load average statistic is indeed broken somehow, and I
> did bisect it down to where the problem began, however there seems to be no
> performance problem related to it I can find. Somehow I must have made a
> mistake I didn't catch when I did the original build that led me to believe
> on top of the statistic being broken, that it was causing a performance
> problem.
> 
> 	All of the make allnoconfig test results finish within a second of
> eachother, with four different kernels tested. I think if there really was a
> performance problem it would have reared its head sometime during the
> multiple compile tests on different kernels I took. I apologize for wasting
> everyones time, especially my own :)

Don't apologize, it's heroic. Do you still see the performance
regression you reported in your original bug report? I don't exactly
know if you are at the moment just talking about the bisected commit or
if the performance regression you saw earlier was just some cosmic ray
kind of thing...

If the load-average thing was just a red herring, it would probably
 still be worthwile to bisect the performance regression.


> Anyway, the results:
> 
> 2.6.35.6:
> make mrproper && XZ_OPT="" CCACHE_DISABLE="1" time make allnoconfig
> 5.46user 0.51system 0:07.08elapsed 84%CPU (0avgtext+0avgdata 95888maxresident)k
> 0inputs+1920outputs (0major+126585minor)pagefaults 0swaps
> 
> 2.6.35:
> make mrproper && XZ_OPT="" CCACHE_DISABLE="1" time make allnoconfig
> 5.42user 0.50system 0:06.24elapsed 95%CPU (0avgtext+0avgdata 95888maxresident)k
> 0inputs+1920outputs (0major+126585minor)pagefaults 0swaps

Hm. Doesn't really look like double the time, does it?


> Tim McGrath
