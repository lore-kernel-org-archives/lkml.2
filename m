Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab0FXKAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 06:00:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60811 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab0FXKAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 06:00:36 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC 4/5] x86, Use NMI return notifier in MCE
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
	<1277348698-17311-4-git-send-email-ying.huang@intel.com>
Date: Thu, 24 Jun 2010 12:00:34 +0200
In-Reply-To: <1277348698-17311-4-git-send-email-ying.huang@intel.com> (Huang
	Ying's message of "Thu, 24 Jun 2010 11:04:57 +0800")
Message-ID: <87eifwagxp.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying <ying.huang@intel.com> writes:

Hi Ying,

>  {
>  	if (regs->flags & (X86_VM_MASK|X86_EFLAGS_IF)) {
> -		mce_notify_irq();
> -		/*
> -		 * Triggering the work queue here is just an insurance
> -		 * policy in case the syscall exit notify handler
> -		 * doesn't run soon enough or ends up running on the
> -		 * wrong CPU (can happen when audit sleeps)
> -		 */
> -		mce_schedule_work();
> +		__mce_report_event(NULL);

Do we still handle the CPU switch case correctly?

The backend handler needs to run on the same CPU to process the per
CPU mce pfns.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
