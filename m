Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab2AQD7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 22:59:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:23906 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782Ab2AQD7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 22:59:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="97231221"
Subject: Re: [patch] x86, tsc: fix SMI induced variation in
 quick_pit_calibrate()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, asit.k.mallick@intel.com
Date: Mon, 16 Jan 2012 20:06:04 -0800
In-Reply-To: <CA+55aFwuwPXatwdJqeW_e_7w_rBELL8HTHqq0FLDiE+xmPm5XQ@mail.gmail.com>
References: <1326744932.16150.9.camel@sbsiddha-desk.sc.intel.com>
	 <CA+55aFys9zddHAoKURGAeu0QYD_MC11uEyOQGU_4Ybsf200NkQ@mail.gmail.com>
	 <1326760869.16150.16.camel@sbsiddha-desk.sc.intel.com>
	 <CA+55aFzGN59W5zhmc-kicQrpomAKLiwX4yBUsNcagwmM=Z8jxw@mail.gmail.com>
	 <CA+55aFwuwPXatwdJqeW_e_7w_rBELL8HTHqq0FLDiE+xmPm5XQ@mail.gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1326773165.16150.35.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-16 at 17:30 -0800, Linus Torvalds wrote:
> On Mon, Jan 16, 2012 at 4:52 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Hmm. I get the feeling that we should remove that line entirely.
> 
> Yeah, I really cannot come up with a single good reason to keep that
> line, and suspect that I was a bit loopy when I wrote it.
> 
> So here's the suggested trivially updated patch. Does this work for people?

It does work. But it is taking almost 105 iterations or so to stabilize.
And if I boot the system in power-save mode (lowest p-state), it takes
almost 115 iterations to stabilize (close to the 25msec limit). This is
on the latest gen platform.

So I suspect we can either go back to 500ppm error tolerance:

                        if ((d1+d2) >= delta >> 10)
                                continue;

or increase the MAX_QUICK_PIT_MS bit more.

thanks,
suresh

