Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760486Ab2FGN1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 09:27:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55732 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760270Ab2FGN1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 09:27:12 -0400
Date: Thu, 7 Jun 2012 15:27:05 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, andi@firstfloor.org,
        mingo@elte.hu, ming.m.lin@intel.com
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on SandyBridge
Message-ID: <20120607132705.GK27374@one.firstfloor.org>
References: <20120607071531.GA4849@quad>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120607071531.GA4849@quad>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	/*
> +	 * check ucode version for SNB, SNB-EP
> +	 */
> +	if ((model == 42 || model == 45) && uversion < 0x28) {

You need to check for x86 == 6 here.

-Andi
> +		pr_warn("SandyBridge PEBS unavailable due to CPU erratum, "
> +			" update microcode (was 0x%x, needs at least 0x28).\n",
> +			uversion);
> +		return -ENOTSUPP;
