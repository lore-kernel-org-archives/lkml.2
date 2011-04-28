Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab1D1MNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 08:13:52 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:45696 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab1D1MNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 08:13:51 -0400
Date: Thu, 28 Apr 2011 17:42:44 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Cc: Nikhil Rao <ncrao@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 00/18] Increase resolution of load weights
Message-ID: <20110428121244.GA26851@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <1303332697-16426-1-git-send-email-ncrao@google.com>
 <m3tydi6ehc.fsf@IBM-009124035060.in.ibm.com>
 <m3wriey4tw.fsf@IBM-009124035060.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3wriey4tw.fsf@IBM-009124035060.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 05:18:27PM +0530, Nikunj A. Dadhania wrote:
> --- kernel/sched.c.orig	2011-04-28 16:34:24.000000000 +0530
> +++ kernel/sched.c	2011-04-28 16:36:29.000000000 +0530
> @@ -1336,7 +1336,7 @@ calc_delta_mine(unsigned long delta_exec
>  			lw->inv_weight = 1 + (WMULT_CONST - w/2) / (w + 1);
>  	}
> 
> -	tmp = (u64)delta_exec * weight;
> +	tmp = (u64)delta_exec * (weight >> SCHED_LOAD_RESOLUTION);

Should we be fixing inv_weight rather to account for SCHED_LOAD_RESOLUTION here?

- vatsa
