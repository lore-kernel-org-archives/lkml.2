Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab0FXH1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 03:27:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:50842 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab0FXH1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 03:27:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,472,1272870000"; 
   d="scan'208";a="811015566"
Subject: Re: [RFC][PATCH] irq_work
From: Huang Ying <ying.huang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H.PeterA" <"nvin hpa"@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <1277363993.1875.847.camel@laptop>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
	 <1277361352.1875.838.camel@laptop>
	 <1277361791.3947.11.camel@yhuang-dev.sh.intel.com>
	 <1277362073.1875.839.camel@laptop>
	 <1277362243.3947.20.camel@yhuang-dev.sh.intel.com>
	 <1277362680.1875.845.camel@laptop>
	 <1277363069.3947.30.camel@yhuang-dev.sh.intel.com>
	 <1277363993.1875.847.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Jun 2010 15:27:33 +0800
Message-ID: <1277364453.3947.64.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 15:19 +0800, Peter Zijlstra wrote:
> On Thu, 2010-06-24 at 15:04 +0800, Huang Ying wrote:
> 
> > Yes. NMI is there from 8259 age.
> 
> But do we really care about such systems?
> 
> > That is possible. But in NO_HZ system, we have no tick to rely on.
> 
> Of course you have, you can delay the NO_HZ state when there's pending
> callbacks, that's all of 1 line.
> 
> > soft_irq is better here, because it will be triggered for any interrupt.
> 
> Well, you can do the callbacks from irq_exit() as well, that's no
> problem.

I think it is not a good idea to add overhead in such a hot path if the
overhead can be avoided.

Best Regards,
Huang Ying


