Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab2AQAez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 19:34:55 -0500
Received: from mga03.intel.com ([143.182.124.21]:8822 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab2AQAey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 19:34:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="57078516"
Subject: Re: [patch] x86, tsc: fix SMI induced variation in
 quick_pit_calibrate()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, asit.k.mallick@intel.com
Date: Mon, 16 Jan 2012 16:41:09 -0800
In-Reply-To: <CA+55aFys9zddHAoKURGAeu0QYD_MC11uEyOQGU_4Ybsf200NkQ@mail.gmail.com>
References: <1326744932.16150.9.camel@sbsiddha-desk.sc.intel.com>
	 <CA+55aFys9zddHAoKURGAeu0QYD_MC11uEyOQGU_4Ybsf200NkQ@mail.gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1326760869.16150.16.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-16 at 16:18 -0800, Linus Torvalds wrote:
> So I think your patch is a total hack that just compares the two last
> TSC deltas, but it's actually close to the "correct' thing in that it
> does start taking the time to see the last of the previous MSB into
> account.

yeah, it was a hack but your alternative sounds good.

> Now the delta is twice as big as before (it covers four PIT accesses,
> roughly 4us), so the comments might have to be updated to match, but
> the rest of the code should "just work" (except it might loop a bit
> longer, and maybe it gives closer to 250 ppm precision).
> 
> Does this fix it for you? I have NOT tested it in any way.
> 

also may be we should change the correction 

from: delta += (long)(d2 - d1)/2;
to:   delta += (long)(d2 - d1)/4;

I will give this patch a try.

thanks,
suresh



