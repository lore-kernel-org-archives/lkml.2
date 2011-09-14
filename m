Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab1INQNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 12:13:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50855 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756997Ab1INQNe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 12:13:34 -0400
Subject: Re: [PATCH 4/7] perf, x86: Implement IBS interrupt handler
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 14 Sep 2011 18:13:25 +0200
In-Reply-To: <1315413376-769-5-git-send-email-robert.richter@amd.com>
References: <1315413376-769-1-git-send-email-robert.richter@amd.com>
	 <1315413376-769-5-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316016805.5040.34.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-07 at 18:36 +0200, Robert Richter wrote:
> +       if (event->attr.sample_type & PERF_SAMPLE_RAW) {
> +               ibs_data.caps = ibs_caps;
> +               size = 1;
> +               offset = 1;
> +               do {
> +                   rdmsrl(msr + offset, *buf++);
> +                   size++;
> +                   offset = find_next_bit(perf_ibs->offset_mask,
> +                                          perf_ibs->offset_max,
> +                                          offset + 1);
> +               } while (offset < perf_ibs->offset_max);
> +               raw.size = sizeof(u32) + sizeof(u64) * size;
> +               raw.data = ibs_data.data;
> +               data.raw = &raw;
> +       } 

Another application of for_each_set_bit_continue() ?
