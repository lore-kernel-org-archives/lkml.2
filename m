Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677Ab1LEWfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 17:35:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:39991 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486Ab1LEWfw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 17:35:52 -0500
Message-ID: <1323124508.32012.46.camel@twins>
Subject: Re: [PATCH 05/12] perf_events: add LBR mappings for
 PERF_SAMPLE_BRANCH filters (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, andi@firstfloor.org, robert.richter@amd.com,
        ravitillo@lbl.gov, will.deacon@arm.com, paulus@samba.org,
        benh@kernel.crashing.org, rth@twiddle.net, ralf@linux-mips.org,
        davem@davemloft.net, lethal@linux-sh.org
Date: Mon, 05 Dec 2011 23:35:08 +0100
In-Reply-To: <1318595833-29984-6-git-send-email-eranian@google.com>
References: <1318595833-29984-1-git-send-email-eranian@google.com>
	 <1318595833-29984-6-git-send-email-eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 14:37 +0200, Stephane Eranian wrote:
>  void intel_pmu_lbr_init_atom(void)
>  {
> +       /*
> +        * only models starting at stepping 10 seems
> +        * to have an operational LBR which can freeze
> +        * on PMU interrupt
> +        */
> +       if (boot_cpu_data.x86_mask < 10) {
> +               pr_cont("LBR disabled due to erratum");
> +               return;
> +       } 

Shouldn't that be a separate patch?
