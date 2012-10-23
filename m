Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab2JWMKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 08:10:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:41153 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab2JWMKD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 08:10:03 -0400
Message-ID: <1350994159.13456.9.camel@twins>
Subject: Re: [PATCH 04/34] perf, x86: Support the TSX intx/intx_cp qualifiers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Date: Tue, 23 Oct 2012 14:09:19 +0200
In-Reply-To: <1350602382-12771-5-git-send-email-andi@firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
	 <1350602382-12771-5-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 16:19 -0700, Andi Kleen wrote:
> @@ -826,7 +827,8 @@ static inline bool intel_pmu_needs_lbr_smpl(struct perf_event *event)
>                 return true;
>  
>         /* implicit branch sampling to correct PEBS skid */
> -       if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1)
> +       if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1 &&
> +           x86_pmu.intel_cap.pebs_format < 2)
>                 return true;
>  
>         return false; 

This seems unrelated to TSX, I suppose it belongs in the previous patch?
