Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab0DSNoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 09:44:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:36706 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab0DSNog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 09:44:36 -0400
Date: Mon, 19 Apr 2010 06:46:17 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "davej@redhat.com" <davej@redhat.com>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with
 ondemand during disk IO
Message-ID: <20100419064617.519eb384@infradead.org>
In-Reply-To: <201004191009.56859.tvrtko.ursulin@sophos.com>
References: <20100418115949.7b743898@infradead.org>
	<20100418120346.1b478410@infradead.org>
	<201004191009.56859.tvrtko.ursulin@sophos.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Apr 2010 10:09:55 +0100
Tvrtko Ursulin <tvrtko.ursulin@sophos.com> wrote:

> Is the improvement really because IO benefited from CPU being held at
> a higher frequency, or perhaps because it is now not scaled down
> during IO, so when CPU intensive part of git grep comes along it is
> already "revved up"?

the IO part does not get much faster (some systems lower the FSB speed
at low frequencies, but disks are still much slower than the FSB
anyway), but the CPU part, which is performance critical for, say,
"git grep" does go faster.


> 
> Or in other words, does a pure IO workload benefit from now higher
> selected frequency?

no.
Mixed workloads do.
but pure IO workloads also don't suffer since while idle, the voltage
goes down anyway.


> 
> One idea I had but a) never had time to implement it and b) was not
> sure it would be accepted anyway, was to modify ondemand governor to
> ramp up instantly, but slow down slowly (in a configurable way).

that's what ondemand does already.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
