Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab2JVKdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 06:33:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:50746 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab2JVKdu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 06:33:50 -0400
Message-ID: <1350902016.2768.85.camel@twins>
Subject: Re: [PATCH 1/6] perf, x86: Basic Haswell LBR call stack support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, ak@linux.intel.com
Date: Mon, 22 Oct 2012 12:33:36 +0200
In-Reply-To: <1350886279-6141-2-git-send-email-zheng.z.yan@intel.com>
References: <1350886279-6141-1-git-send-email-zheng.z.yan@intel.com>
	 <1350886279-6141-2-git-send-email-zheng.z.yan@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-22 at 14:11 +0800, Yan, Zheng wrote:
> +       /* LBR callstack does not work well with FREEZE_LBRS_ON_PMI */
> +       if (!cpuc->lbr_sel || !(cpuc->lbr_sel->config & LBR_CALL_STACK))
> +               debugctl |= DEBUGCTLMSR_FREEZE_LBRS_ON_PMI; 

How useful it is without this? How many calls between PMI and us getting
to intel_pmu_lbr_read()?
