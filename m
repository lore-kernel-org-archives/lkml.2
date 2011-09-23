Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab1IWLtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 07:49:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:59679 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab1IWLtM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 07:49:12 -0400
Subject: Re: [V3][PATCH 0/7] perf, x86: Implement AMD IBS
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Date: Fri, 23 Sep 2011 13:48:43 +0200
In-Reply-To: <1316597423-25723-1-git-send-email-robert.richter@amd.com>
References: <1316597423-25723-1-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316778523.9084.17.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-21 at 11:30 +0200, Robert Richter wrote:
> This patch set adds support for AMD IBS to perf. It is a new
> implementation and unrelated to my previous postings last year. The
> main differences are:
> 
> * separate and independent from x86 perfctrs, IBS could be used
>   without the x86 pmu,
> * using dynamic pmu allocation, userspace uses sysfs to select the pmu,
> * support for 64 bit counters,
> * libperf based example code,
> * shared IBS initialziation code for perf and oprofile.
> 
> The approach is still to collect raw sample data which should be the
> most important use case for application developers. The data format is
> the same as described in the IBS register specification.
> 
> Future work could be:
> 
> * better integration into the perf tool, use IBS for generic events
>   where possible,
> * support of the precise event sampling perf i/f,
> * implementation of extended IBS features (e.g. ext. counter width),
> * support of counting (perf stat),
> * in-kernel IBS event parsing,
> * IBS tracepoint support.

There was also the thing about putting perf_event_set_period() and
perf_event_try_update() in a common library and converting all pmu
implementations to use them.

As well as the for_each_set_bit_continue() thing which you've got
queued.

Anyway, I read through the stuff and it looks about right, so I'll wait
for Don to post his NMI infrastructure bits once more (he had some
pending changes) and then I'll queue this on top.

The only thing I'm not quite sure on is the userspace bits, but those
are in the future work section as well, but possibly Ingo has a strong
opinion here, sadly he doesn't have email atm :/


