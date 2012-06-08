Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab2FHLQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 07:16:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57357 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab2FHLQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 07:16:02 -0400
Date: Fri, 8 Jun 2012 04:14:21 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Minchan Kim <minchan@kernel.org>
Cc: leonid.moiseichuk@nokia.com, penberg@kernel.org, kosaki.motohiro@gmail.com,
        john.stultz@linaro.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 0/5] Some vmevent fixes...
Message-ID: <20120608111421.GA18696@lizard>
References: <4FCD14F1.1030105@gmail.com>
 <CAOJsxLHR4wSgT2hNfOB=X6ud0rXgYg+h7PTHzAZYCUdLs6Ktug@mail.gmail.com>
 <20120605083921.GA21745@lizard>
 <4FD014D7.6000605@kernel.org>
 <20120608074906.GA27095@lizard>
 <4FD1BB29.1050805@kernel.org>
 <CAOJsxLHPvg=bsv+GakFGHyJwH0BoGA=fmzy5bwqWKNGryYTDtg@mail.gmail.com>
 <84FF21A720B0874AA94B46D76DB98269045F7B42@008-AM1MPN1-004.mgdnok.nokia.com>
 <20120608094507.GA11963@lizard>
 <20120608104204.GA2185@barrios>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120608104204.GA2185@barrios>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 07:42:04PM +0900, Minchan Kim wrote:
[...]
> I can't understand. Why can't the approach catch the situation?
> Let's think about it.
> 
> There is 40M in CleanCache LRU which has easy-reclaimable pages and
> there is 10M free pages and 5M high watermark in system.
> 
> Your application start to consume free pages very slowly.
> So when your application consumed 5M, VM start to reclaim. So far, it's okay
> because we have 40M easy-reclaimable pages. And low memory notifier can start
> to notify so your dameon can do some action to get free pages.

Maybe I'm missing how would you use the shrinker. But the last time
I tried on my (swap-less, FWIW) qemu test setup, I was not receiving
any notifications from the shrinker until the system was almost
(but not exactly) out of memory.

My test app was allocating all memory MB by MB, filling the memory
with zeroes. So, what I was observing is that shrinker callback was
called just a few MB before OOM, not every 'X' consumed MBs.

> I think it's not so late.
> 
> sidenote:
> It seems I live in the complete opposite place because
> you guys always start discussion when I am about going out of office.
> Please understand my late response.
> Maybe I will come back after weekend. :)

Well, it's 4AM here. :-) Have a great weekend!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
