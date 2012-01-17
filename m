Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751026Ab2AQFQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 00:16:17 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:55089 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702Ab2AQFQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 00:16:16 -0500
MIME-Version: 1.0
In-Reply-To: <1326773165.16150.35.camel@sbsiddha-desk.sc.intel.com>
References: <1326744932.16150.9.camel@sbsiddha-desk.sc.intel.com>
 <CA+55aFys9zddHAoKURGAeu0QYD_MC11uEyOQGU_4Ybsf200NkQ@mail.gmail.com>
 <1326760869.16150.16.camel@sbsiddha-desk.sc.intel.com> <CA+55aFzGN59W5zhmc-kicQrpomAKLiwX4yBUsNcagwmM=Z8jxw@mail.gmail.com>
 <CA+55aFwuwPXatwdJqeW_e_7w_rBELL8HTHqq0FLDiE+xmPm5XQ@mail.gmail.com> <1326773165.16150.35.camel@sbsiddha-desk.sc.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Jan 2012 21:15:54 -0800
X-Google-Sender-Auth: V4T-LMQzY00znrFkrlnPU3KBKh4
Message-ID: <CA+55aFxjzr3qugZdfsPGPw8RooTCzTr4XQubcqjvF=t+GLHE0Q@mail.gmail.com>
Subject: Re: [patch] x86, tsc: fix SMI induced variation in quick_pit_calibrate()
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, asit.k.mallick@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 8:06 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
>
> So I suspect we can either go back to 500ppm error tolerance:
>
>                        if ((d1+d2) >= delta >> 10)
>                                continue;
>
> or increase the MAX_QUICK_PIT_MS bit more.

Agreed. Either works for me. I think I'd prefer increasing
MAX_QUICK_PIT_MS, because 25ms is still a fairly short time, but the
better we can make the precision of the clock, the better off we'll be
later.

So let's just double MAX_QUICK_PIT_MS to 50, ok?

And since you've tested it, I'm perfectly happy to sign off on that
patch so you can add my signed-off-by line. And if you can write a
reasonable description for it, maybe we can get Ingo & co to apply it.

              Linus
