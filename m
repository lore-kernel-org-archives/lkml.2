Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781Ab2FEH74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 03:59:56 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:49889 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756952Ab2FEH7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 03:59:54 -0400
X-AuditID: 9c93016f-b7c3cae000001954-09-4fcdbc787f24
Message-ID: <4FCDBC8E.1000705@kernel.org>
Date: Tue, 05 Jun 2012 17:00:14 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Pekka Enberg <penberg@kernel.org>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 0/5] Some vmevent fixes...
References: <CAOJsxLHQcDZSHJZg+zbptqmT9YY0VTkPd+gG_zgMzs+HaV_cyA@mail.gmail.com> <CAHGf_=q1nbu=3cnfJ4qXwmngMPB-539kg-DFN2FJGig8+dRaNw@mail.gmail.com> <CAOJsxLFAavdDbiLnYRwe+QiuEHSD62+Sz6LJTk+c3J9gnLVQ_w@mail.gmail.com> <CAHGf_=pSLfAue6AR5gi5RQ7xvgTxpZckA=Ja1fO1AkoO1o_DeA@mail.gmail.com> <CAOJsxLG1+zhOKgi2Rg1eSoXSCU8QGvHVED_EefOOLP-6JbMDkg@mail.gmail.com> <20120601122118.GA6128@lizard> <alpine.LFD.2.02.1206032125320.1943@tux.localdomain> <4FCC7592.9030403@kernel.org> <20120604113811.GA4291@lizard> <20120604121722.GA2768@barrios> <20120604133527.GA13650@lizard> <CAOJsxLHkzubReaR0utB4xdage0Omb4r=jhXCLwXQ8XOSct4LGg@mail.gmail.com>
In-Reply-To: <CAOJsxLHkzubReaR0utB4xdage0Omb4r=jhXCLwXQ8XOSct4LGg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peakk,

On 06/05/2012 04:53 PM, Pekka Enberg wrote:

> On Mon, Jun 4, 2012 at 4:35 PM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
>>> I don't mean VMEVENT_ATTR_LOWMEM_PAGES but following as,
>>>
>>> VMEVENT_ATTR_NR_FREE_PAGES
>>> VMEVENT_ATTR_NR_SWAP_PAGES
>>> VMEVENT_ATTR_NR_AVAIL_PAGES
>>>
>>> I'm not sure how it is useful.
>>
>> Yep, these raw values are mostly useless, and personally I don't use
>> these plain attributes. I use heuristics, i.e. "blended" attributes.
>> If we can come up with levels-based approach w/o using vmstat, well..
>> OK then.
> 
> That's what Nokia's lowmem notifier uses. We can probably drop them
> once we have something else they could use.


Next concern is that periodic timer of implementation.
I think it would add direct hook in vmscan.c rather than peeking raw vmstat periodically by timer
so we can control more fine-grained way without unnecessary overhead.

-- 
Kind regards,
Minchan Kim
