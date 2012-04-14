Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab2DNKV6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 06:21:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34272 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab2DNKV5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 06:21:57 -0400
Message-ID: <1334398906.2528.49.camel@twins>
Subject: Re: [PATCH 06/12] perf/x86-ibs: Precise event sampling with IBS for
 AMD CPUs
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 14 Apr 2012 12:21:46 +0200
In-Reply-To: <1333390758-10893-7-git-send-email-robert.richter@amd.com>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
	 <1333390758-10893-7-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-02 at 20:19 +0200, Robert Richter wrote:
> + * We map IBS sampling to following precise levels:
> + *
> + *  1: RIP taken from IBS sample or (if invalid) from stack
> + *  2: RIP always taken from IBS sample, samples with an invalid rip
> + *     are dropped. Thus samples of an event containing two precise
> + *     modifiers (e.g. r076:pp) only contain (precise) addresses
> + *     detected with IBS.

		/*
		 * precise_ip:
		 *
		 *  0 - SAMPLE_IP can have arbitrary skid
		 *  1 - SAMPLE_IP must have constant skid
		 *  2 - SAMPLE_IP requested to have 0 skid
		 *  3 - SAMPLE_IP must have 0 skid
		 *
		 *  See also PERF_RECORD_MISC_EXACT_IP
		 */

your 1 doesn't have constant skid. I would suggest only supporting 2 and
letting userspace drop !PERF_RECORD_MISC_EXACT_IP records if so desired.

That said, mixing the IBS pmu into the regular core pmu isn't exactly
pretty..
