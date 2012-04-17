Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab2DQMJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 08:09:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:47523 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451Ab2DQMJY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 08:09:24 -0400
Message-ID: <1334664553.28150.87.camel@twins>
Subject: Re: load balancing regression since commit 367456c7
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Alex Shi <alex.shi@intel.com>,
        Ying <ying.huang@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 17 Apr 2012 14:09:13 +0200
In-Reply-To: <1334106376.19157.89.camel@schen9-DESK>
References: <1334106376.19157.89.camel@schen9-DESK>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-10 at 18:06 -0700, Tim Chen wrote:
>                   |--56.52%-- load_balance
>                   |          idle_balance
>                   |          __schedule
>                   |          schedule 

Ahh, I know why I didn't see it, I have a CONFIG_PREEMPT kernel and
idle_balancing stops once its gotten a single task over instead of
achieving proper balance.

And since hackbench generates insanely long runqueues and the patch that
caused your regression 'fixed' the lock-breaking it will now iterate the
entire runqueue if needed to achieve balance, which hurts.

I think the patch I send ought to work, let me try disabling
CONFIG_PREEMPT.
