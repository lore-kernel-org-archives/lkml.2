Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab2LJWg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 17:36:57 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:53348 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab2LJWgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 17:36:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Julius Werner <jwerner@chromium.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Francesco Lavra <francescolavra.fl@gmail.com>,
        linux-pm@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>, len.brown@intel.com,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Sameer Nanda <snanda@chromium.org>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC] cpuidle - remove the power_specified field in the driver
Date: Mon, 10 Dec 2012 23:41:55 +0100
Message-ID: <1720382.g37yj6OOdX@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc8; KDE/4.9.3; x86_64; ; )
In-Reply-To: <CAODwPW96ZTXUZjz4B_GET_6UAd4oTednRmrFLe-Jt=EF9n4O1g@mail.gmail.com>
References: <50831CA3.2020602@linaro.org> <50A8A7BB.2070809@linaro.org> <CAODwPW96ZTXUZjz4B_GET_6UAd4oTednRmrFLe-Jt=EF9n4O1g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 10, 2012 11:09:58 AM Julius Werner wrote:
> Hi,
> 
> What is the current status of this? Daniel, do you think you have got
> enough feedback to submit a definitive patch for this? Rafael, would
> you approve of such a change?

I need to talk to Len about that before I give you a reliable answer.

Thanks,
Rafael


> The bug with dynamically added C-states that is tied to this still
> hurts the battery life for some users across all distros every day, so
> I think it would be valuable to get a consistent solution into the
> mainline soon before everyone has to roll their own.
> 
> On 11/12/2012 09:26 PM, Daniel Lezcano wrote:
> > This patch follows the discussion about reinitializing the power usage
> > when a C-state is added/removed.
> >
> >  https://lkml.org/lkml/2012/10/16/518
> >
> > We realized the power usage field is never filled and when it is
> > filled for tegra, the power_specified flag is not set making all these
> > values to be resetted when the driver is initialized with the set_power_state
> > function.
> >
> > Julius and I feel this is over-engineered and the power_specified
> > flag could be simply removed and continue assuming the states are
> > backward sorted.
> >
> > The menu governor select function is simplified as the power is ordered.
> > Actually the condition is always true with the current code.
> >
> > The cpuidle_play_dead function is also simplified by doing a reverse lookup
> > on the array.
> >
> > The set_power_states function is removed as it does no make sense anymore.
> >
> > Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> > ---
> >  drivers/cpuidle/cpuidle.c        |   17 ++++-------------
> >  drivers/cpuidle/driver.c         |   25 -------------------------
> >  drivers/cpuidle/governors/menu.c |    8 ++------
> >  include/linux/cpuidle.h          |    2 +-
> >  4 files changed, 7 insertions(+), 45 deletions(-)
> >
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
