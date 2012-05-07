Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab2EGNDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 09:03:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59033 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab2EGNDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 09:03:16 -0400
Subject: Re: [PATCH 4/7] perf/x86-ibs: Add support for IBS pseudo events
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1335983192-23731-5-git-send-email-robert.richter@amd.com>
References: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
	 <1335983192-23731-5-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 May 2012 15:03:02 +0200
Message-ID: <1336395782.27020.37.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 20:26 +0200, Robert Richter wrote:
> +enum ibs_filter_type {
> +       IBS_NO_FILTER           = 0,
> +       IBS_MATCH_FILTER        = 1,
> +       IBS_ANY_SET_FILTER      = 2,
> +       IBS_PSEUDO_EVENT        = 0x0F,
> +};

I don't get how those pseudo events work, AFAIKT IBS_PSEUDO_EVENT causes
one to loose all events since it does have a filter set but fails the
filter and thus we skip the call to perf_event_overflow().

Furthermore, I think this filter stuff should accumulate the period so
that PERF_SAMPLE_PERIOD still works correctly and reflects the number of
counts since the last sample.

Also, what's the point of filtering in-kernel as opposed to doing all
this in userspace? Is the amount of data 'saved' significant enough?



