Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab2DNKZM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 06:25:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:58873 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab2DNKZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 06:25:10 -0400
Message-ID: <1334399098.2528.52.camel@twins>
Subject: Re: [PATCH 06/12] perf/x86-ibs: Precise event sampling with IBS for
 AMD CPUs
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 14 Apr 2012 12:24:58 +0200
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
> +       switch (event->attr.type) {
> +       case PERF_TYPE_HARDWARE:
> +               switch (event->attr.config) {
> +               case PERF_COUNT_HW_CPU_CYCLES:
> +                       *config = 0;
> +                       return 0;
> +               }
> +               break;
> +       case PERF_TYPE_RAW:
> +               switch (event->attr.config) {
> +               case 0x0076:
> +                       *config = 0;
> +                       return 0;
> +               case 0x00C1:
> +                       *config = IBS_OP_CNT_CTL;
> +                       return 0;
> +               }
> +               break;
> +       default:
> +               return -ENOENT;
> +       } 

Another option would be to do this from amd_pmu_hw_config() after you've
already gotten rid of the whole attr.type thing.
