Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626Ab2CZWpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 18:45:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:44546 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302Ab2CZWpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 18:45:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="133382332"
Subject: Re: [patch] x86, tlb: switch cr3 in leave_mm() only when needed
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 26 Mar 2012 15:47:05 -0700
In-Reply-To: <20120323083751.GC2886@gmail.com>
References: <1332459220.16101.144.camel@sbsiddha-desk.sc.intel.com>
	 <CA+55aFyf9RqAROx7t=CYUSGCDBXvv9z2c+LP1vRJjLU45_pD+Q@mail.gmail.com>
	 <1332460885.16101.147.camel@sbsiddha-desk.sc.intel.com>
	 <4F6BC1C4.6050502@zytor.com>
	 <CA+55aFygUGmL0iCKYn5DBitrPSm0GHZ8e5j0j2OzcBcAkUMiFw@mail.gmail.com>
	 <1332463899.16101.158.camel@sbsiddha-desk.sc.intel.com>
	 <20120323083751.GC2886@gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1332802025.12381.2.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-23 at 09:37 +0100, Ingo Molnar wrote:
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
> > I was reviewing this code in some other context and thought 
> > this optimization makes sense. Unless someone beats me, I can 
> > collect some data on Monday.
> 
> Would be really nice to get this data.
> 

On an idle system with 32logical cpu's (2 socket/8-core each) the
original kernel did the unnecessary load_cr3 2988 times during an
interval of 5 seconds.

With the fix, that count drops to 9 times.

thanks,
suresh

