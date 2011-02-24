Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab1BXOCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 09:02:21 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44794 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab1BXOCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 09:02:20 -0500
Date: Thu, 24 Feb 2011 15:02:15 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf: x86, add SandyBridge support
Message-ID: <20110224140214.GI5818@one.firstfloor.org>
References: <1298555968.2220.15.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298555968.2220.15.camel@localhost>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	[ C(OP_READ) ] = {
> +		[ C(RESULT_ACCESS) ] = 0x04d1, /* MEM_LOAD_UOPS_RETIRED.LLC_HIT */
> +		[ C(RESULT_MISS)   ] = 0x0,
> +	},
> +	[ C(OP_WRITE) ] = {
> +		[ C(RESULT_ACCESS) ] = 0x0424, /* L2_RQSTS.RFO_HITS */
> +		[ C(RESULT_MISS)   ] = 0x0824, /* L2_RQSTS.RFO_MISS */

No! You really need offcore here. L2 is not LLC!!!
See the offcore patchkit which fixes this for Nehalem.

-Andi
