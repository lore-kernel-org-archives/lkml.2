Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab1HBLh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 07:37:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49825 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab1HBLhy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 07:37:54 -0400
Subject: Re: [PATCH 7/7] perf, x86: Implement 64 bit counter support for IBS
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1311860812-28748-8-git-send-email-robert.richter@amd.com>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
	 <1311860812-28748-8-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 02 Aug 2011 13:37:20 +0200
Message-ID: <1312285040.1147.108.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-28 at 15:46 +0200, Robert Richter wrote:
> +       /*
> +        * Emulate IbsOpCurCnt in MSRC001_1033 (IbsOpCtl), not
> +        * supported in all cpus. As this triggered an interrupt, we
> +        * set the current count to the max count.
> +        */
> +       config = buffer[0];
> +       if (perf_ibs == &perf_ibs_op) {
> +               config &= ~IBS_OP_CUR_CNT;
> +               config |= (config & IBS_OP_MAX_CNT) << 36;
> +       } 

Shouldn't that be conditional on capability muck?
