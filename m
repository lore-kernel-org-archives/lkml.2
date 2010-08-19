Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab0HSWYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 18:24:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:39441 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab0HSWYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 18:24:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,235,1280732400"; 
   d="scan'208";a="546960915"
Message-ID: <1877.10.21.68.23.1282256686.squirrel@linux.intel.com>
Date: Thu, 19 Aug 2010 15:24:46 -0700 (PDT)
Subject: Re: [PATCH  1/1] mutex: prevent optimistic spinning from spinning  
                        longer than neccessary (Repost)
From: "Tim Chen" <tim.c.chen@linux.intel.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Tim Chen" <tim.c.chen@linux.intel.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        peterz@infradead.org, "Andrew Morton" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Andi Kleen" <ak@linux.intel.com>,
        "Tony Luck" <tony.luck@intel.com>
Reply-To: tim.c.chen@linux.intel.com
User-Agent: SquirrelMail/1.4.8-5.el4.centos.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
References: <1282168827.9542.72.camel@schen9-DESK>            
    <20100819110511.GA16264@elte.hu>
In-Reply-To: <20100819110511.GA16264@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ingo wrote:
>
> These are some rather impressive speedups!
>
> Have you tried to see what performance effects this change has on
smaller
> boxes? Just to see what flip side (if any) this change has.
>

I've done similar experiments with 2.6.35 kernel on smaller boxes.  One is
on a dual-socket Westmere box (12 cores total, with HT). Another
experiment is on an old dual-socket Core 2 box (4 cores total, no HT)

On the 12-core Westmere box, I see a 250% increase for Ingo's mutex-test
program with my mutex patch but no significant difference in aim7's
fserver workload.

On the 4-core Core 2 box, I see the difference with the patch for both
mutex-test and aim7 fserver are negligible.

So far, it seems like the patch has not caused regression on smaller
systems.  We'll put it through more workloads to check.

Tim









