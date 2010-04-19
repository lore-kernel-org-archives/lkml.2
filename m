Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab0DSJKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 05:10:06 -0400
Received: from mx3.sophos.com ([74.202.89.160]:60947 "EHLO mx3.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582Ab0DSJKE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 05:10:04 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with ondemand during disk IO
Date: Mon, 19 Apr 2010 10:09:55 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-desktop; KDE/4.3.5; x86_64; ; )
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "davej@redhat.com" <davej@redhat.com>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
References: <20100418115949.7b743898@infradead.org> <20100418120346.1b478410@infradead.org>
In-Reply-To: <20100418120346.1b478410@infradead.org>
MIME-Version: 1.0
Message-ID: <201004191009.56859.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 19/04/2010 10:09:56,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 19/04/2010 10:09:57,
	Serialize complete at 19/04/2010 10:09:57
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 Apr 2010 20:03:46 Arjan van de Ven wrote:
> The ondemand cpufreq governor uses CPU busy time (e.g. not-idle time) as
> a measure for scaling the CPU frequency up or down.
> If the CPU is busy, the CPU frequency scales up, if it's idle, the CPU
> frequency scales down. Effectively, it uses the CPU busy time as proxy
> variable for the more nebulous "how critical is performance right now"
> question.
>
> This algorithm falls flat on its face in the light of workloads where
> you're alternatingly disk and CPU bound, such as the ever popular
> "git grep", but also things like startup of programs and maildir using
> email clients... much to the chagarin of Andrew Morton.
>
> This patch changes the ondemand algorithm to count iowait time as busy,
> not idle, time. As shown in the breakdown cases above, iowait is
>  performance critical often, and by counting iowait, the proxy variable
>  becomes a more accurate representation of the "how critical is
>  performance" question.

Is the improvement really because IO benefited from CPU being held at a higher
frequency, or perhaps because it is now not scaled down during IO, so when CPU
intensive part of git grep comes along it is already "revved up"?

Or in other words, does a pure IO workload benefit from now higher selected
frequency?

One idea I had but a) never had time to implement it and b) was not sure it
would be accepted anyway, was to modify ondemand governor to ramp up
instantly, but slow down slowly (in a configurable way). Or to make it a hybrid
of conservative and ondemand in a way. (This was all long time ago so perhaps
today what I wanted to do then is already achievable with some knobs.) It was
not an idea out of thin air, but based on unpleasant desktop latencies with
ondemand, while performance governor was of course perfect.

Tvrtko




Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
