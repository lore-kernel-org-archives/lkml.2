Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487Ab1G2NKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 09:10:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756360Ab1G2NKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 09:10:16 -0400
Date: Fri, 29 Jul 2011 09:10:09 -0400
From: Don Zickus <dzickus@redhat.com>
To: ZAK Magnus <zakmagnus@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH v3 2/2] Make hard lockup detection use timestamps
Message-ID: <20110729131009.GQ2581@redhat.com>
References: <1311271873-10879-1-git-send-email-zakmagnus@google.com>
 <20110722195340.GF3765@redhat.com>
 <CAAuSN93tiSehpNXxjOgrq7oV-U+1ZPi2eqr+2dNSBG0yu0jxmA@mail.gmail.com>
 <20110725124451.GA2866@redhat.com>
 <CAAuSN93Qjk4eEAvm_Xn=O-0t+qhAyKmxy6HyPuyzJ35tX2u_CQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAuSN93Qjk4eEAvm_Xn=O-0t+qhAyKmxy6HyPuyzJ35tX2u_CQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 05:16:00PM -0700, ZAK Magnus wrote:
> No news?
> 
> I've been testing and looking into issues and I realized dump_stack()
> calls touch_nmi_watchdog(). That wrecks what the patch is trying to do
> so I'm changing it to save the trace and print it later after the
> stall has completed. This would also resolve some other things you
> were saying weren't so good. Hopefully the logic is similar enough
> that some things you may have learned still apply.

Sorry, I have been caught up with a bunch of other work related issues
here.  I should be able to poke at this today.

Yeah, I forgot about the console write path.  That was causing another
separate problem for me a while ago with softlockups causing a
touch_nmi_watchdog on all cpus.  I still have to trade fixes to get that
in.

Cheers,
Don
