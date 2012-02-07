Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab2BGKZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 05:25:27 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:65482 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab2BGKZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 05:25:26 -0500
Message-ID: <1328610322.2232.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH] perf: fix assertion failure in x86_pmu_start()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, markus@trippelsdorf.de, paulus@samba.org
Date: Tue, 07 Feb 2012 11:25:22 +0100
In-Reply-To: <20120207084156.GA15359@elte.hu>
References: <20120206205354.GA31186@quad>
	 <1328603689.2476.15.camel@edumazet-laptop> <20120207084156.GA15359@elte.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 07 février 2012 à 09:41 +0100, Ingo Molnar a écrit :

> Were these messages introduced by:
> 
>  e050e3f0a71b: perf: Fix broken interrupt rate throttling
> 
> as well?
> 
> In any case I'm holding off on applying the patch before this is 
> resolved.

Reverting e050e3f0a71b solves all my problems, no more warnings.

$ perf record -a -g hackbench 10 thread 4000
Running with 10*40 (== 400) tasks.
Time: 13.181
[ perf record: Woken up 59 times to write data ]
[ perf record: Captured and wrote 16.874 MB perf.data (~737228 samples)
]

$ perf record -a -g hackbench 10 thread 4000
Running with 10*40 (== 400) tasks.
Time: 13.124
[ perf record: Woken up 61 times to write data ]
[ perf record: Captured and wrote 16.533 MB perf.data (~722349 samples)
]


