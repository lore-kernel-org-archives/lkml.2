Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab0FXGqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 02:46:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:34907 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab0FXGqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 02:46:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,472,1272870000"; 
   d="scan'208";a="633139908"
Subject: Re: [RFC 1/5] Make soft_irq NMI safe
From: Huang Ying <ying.huang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H.PeterA" <"nvin hpa"@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <1277359779.1875.833.camel@laptop>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
	 <1277359779.1875.833.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Jun 2010 14:45:58 +0800
Message-ID: <1277361958.3947.14.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 14:09 +0800, Peter Zijlstra wrote:
> On Thu, 2010-06-24 at 11:04 +0800, Huang Ying wrote:
> > +#define __raise_softirq_preempt_off(nr)                                        \
> > +       do { set_bit(nr, (unsigned long *)local_softirq_pending()); } while (0) 
> 
> So that is the reason for that insane local_softirq_pending()
> definition?

I need to change local_softirq_pending() for this and the xchg() in
__do_softirq().

Best Regards,
Huang Ying


