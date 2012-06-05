Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414Ab2FEITI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 04:19:08 -0400
Received: from smtp.nokia.com ([147.243.1.48]:32490 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756291Ab2FEITF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 04:19:05 -0400
From: <leonid.moiseichuk@nokia.com>
To: <penberg@kernel.org>, <minchan@kernel.org>
CC: <cbouatmailru@gmail.com>, <kosaki.motohiro@gmail.com>,
        <john.stultz@linaro.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linaro-kernel@lists.linaro.org>,
        <patches@linaro.org>, <kernel-team@android.com>
Subject: RE: [PATCH 0/5] Some vmevent fixes...
Thread-Topic: [PATCH 0/5] Some vmevent fixes...
Thread-Index: AQHNP/FOitsSrN1KnkOrXYpeZEkA+pboy3gAgADvzACAADBdAIAACvEAgAAV0wCAATLWgIAAAdUAgAAAbICAACQwcA==
Date: Tue, 5 Jun 2012 08:16:12 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB98269045EBBD8@008-AM1MPN1-003.mgdnok.nokia.com>
References: <CAOJsxLHQcDZSHJZg+zbptqmT9YY0VTkPd+gG_zgMzs+HaV_cyA@mail.gmail.com>
	<CAHGf_=q1nbu=3cnfJ4qXwmngMPB-539kg-DFN2FJGig8+dRaNw@mail.gmail.com>
	<CAOJsxLFAavdDbiLnYRwe+QiuEHSD62+Sz6LJTk+c3J9gnLVQ_w@mail.gmail.com>
	<CAHGf_=pSLfAue6AR5gi5RQ7xvgTxpZckA=Ja1fO1AkoO1o_DeA@mail.gmail.com>
	<CAOJsxLG1+zhOKgi2Rg1eSoXSCU8QGvHVED_EefOOLP-6JbMDkg@mail.gmail.com>
	<20120601122118.GA6128@lizard>
	<alpine.LFD.2.02.1206032125320.1943@tux.localdomain>
	<4FCC7592.9030403@kernel.org>	<20120604113811.GA4291@lizard>
	<20120604121722.GA2768@barrios>	<20120604133527.GA13650@lizard>
	<CAOJsxLHkzubReaR0utB4xdage0Omb4r=jhXCLwXQ8XOSct4LGg@mail.gmail.com>
	<4FCDBC8E.1000705@kernel.org>
 <CAOJsxLHOdnQKSfLqFG4hdabhuwhHt+HqKGerP23YuNQc4TZS_g@mail.gmail.com>
In-Reply-To: <CAOJsxLHOdnQKSfLqFG4hdabhuwhHt+HqKGerP23YuNQc4TZS_g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.162.64.195]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 05 Jun 2012 08:16:13.0249 (UTC) FILETIME=[78A9C310:01CD42F3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: penberg@gmail.com [mailto:penberg@gmail.com] On Behalf Of ext
> Pekka Enberg
> Sent: 05 June, 2012 11:02
> To: Minchan Kim
...
> > Next concern is that periodic timer of implementation.
> > I think it would add direct hook in vmscan.c rather than peeking raw
> > vmstat periodically by timer so we can control more fine-grained way
> without unnecessary overhead.
> 
> If the hooks are clean and it doesn't hurt the  !CONFIG_VMEVENT case, I'm
> completely OK with that.

On the previous iteration hooking vm was pointed as very bad idea, so in my version I installed shrinker to handle cases when we have memory pressure.
Using deferred timer with adequate timeout (0.250 ms or larger) fully suitable for userspace and produce adequate overhead 
-> by nature such API should not be 100% accurate, anyhow applications cannot handle situation as good as kernel can provide, 0.5MB space accuracy, 100ms is maximum user-space require for 64-1024MB devices.
