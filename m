Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab1BCTQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 14:16:32 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:34288 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529Ab1BCTQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 14:16:30 -0500
Subject: Re: [PATCH 0/4] RTC regression fixups
From: John Stultz <john.stultz@linaro.org>
To: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <AANLkTimO5FXDoA_egZ=7oR5FTV-Fx5qpjfPRZ7eT1q50@mail.gmail.com>
References: <1296699283-6784-1-git-send-email-john.stultz@linaro.org>
	 <AANLkTimO5FXDoA_egZ=7oR5FTV-Fx5qpjfPRZ7eT1q50@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Feb 2011 11:16:16 -0800
Message-ID: <1296760576.3336.324.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-03 at 15:30 -0200, Marcelo Roberto Jimenez wrote:
> Hi John,
> 
> On Thu, Feb 3, 2011 at 00:14, John Stultz <john.stultz@linaro.org> wrote:
> > ...
> > Marcelo: Mind giving this full patch set a go? It seems to resolve
> > the issues in my testing with the rtc-test driver.
> 
> I have tested the full set in ARM sa1100. Both the sa1100 RTC driver
> and the rtc-test driver are working fine.

Great to hear! Thanks for testing!

> The only difference in user space behaviour is, as I have mentioned on
> a previous message, that the rtc-test driver receives PIE events no
> matter what, while the previous behaviour was to receive them by
> echoing through the sys interface. But we must think whether this is
> something worth keeping or not.

Yes. With the generic code emulating PIE mode interrupts with an
hrtimer, instead of having it be driver triggered, its not something the
driver can control. So dropping the PIE control in the rtc-test driver
seems like the right approach.

Alessandro: Does this sound ok to you?

> You have actually saved me some work fixing the alarm/update broken
> behaviour on sa1100. Thank you very much. Most of the code in this rtc
> driver is going to /dev/null, I'll send a patch later.

Great. I'll add it to the follow on cleanup patches to remove dead code
that I'll be working on getting in my queue today.

thanks
-john

