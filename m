Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab1HAPRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 11:17:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33569 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab1HAPRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 11:17:06 -0400
Subject: Re: [PATCH 4/7] perf, x86: Implement IBS interrupt handler
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
In-Reply-To: <20110801053201.GY4590@erda.amd.com>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
	 <1311860812-28748-5-git-send-email-robert.richter@amd.com>
	 <1311958726.5890.411.camel@twins>  <20110801053201.GY4590@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Aug 2011 17:21:43 +0200
Message-ID: <1312212103.2617.495.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-01 at 07:32 +0200, Robert Richter wrote:
> > So IBS cannot trigger the whole unknown NMI business? Wouldn't ibs_op
> > triggering while ibs_fetch just started latch the NMI line, the
> > in-progress NMI would handle both, and we then end up with a spare NMI?
> 
> Ok, I will run some excessive testing of this. If this turns out to be
> a problem I will change the code. Could this be on top of this patch
> set then? 

Sure, if you somehow end up duplicating some logic I think you know
about this common.c file you proposed ;-)

I kinda lost the current state of affairs wrt spurious NMIs, I think
there's still a few reports out there. I recently read through some
Intel errata and found the Intel PMU can send double PMIs under some
circumstances (just to keep life interesting).

I also haven't checked up on what the perf_event_nmi_handler() magic
looks today, so I can't say if its a problem or not, but I thought I'd
just mention it.

