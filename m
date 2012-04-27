Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759770Ab2D0D5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 23:57:25 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64200 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759665Ab2D0D5Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 23:57:24 -0400
MIME-Version: 1.0
In-Reply-To: <201204270004.27958.rjw@sisk.pl>
References: <201202070200.55505.rjw@sisk.pl>
	<201204242327.17626.rjw@sisk.pl>
	<20120426163143.42f707b0@notabene.brown>
	<201204270004.27958.rjw@sisk.pl>
Date: Thu, 26 Apr 2012 20:57:22 -0700
Message-ID: <CAMP5Xgce6EPfpCaYN+34iuUxLpV9j9LoWYrQ21xcJiANuQ3VpQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 8/8] PM / Sleep: Add user space interface for
 manipulating wakeup sources
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: NeilBrown <neilb@suse.de>, John Stultz <johnstul@us.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/26 Rafael J. Wysocki <rjw@sisk.pl>:
...
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / Sleep: Add user space interface for manipulating wakeup sources, v3
>
> Android allows user space to manipulate wakelocks using two
> sysfs file located in /sys/power/, wake_lock and wake_unlock.
> Writing a wakelock name and optionally a timeout to the wake_lock
> file causes the wakelock whose name was written to be acquired (it
> is created before is necessary), optionally with the given timeout.
> Writing the name of a wakelock to wake_unlock causes that wakelock
> to be released.
>
> Implement an analogous interface for user space using wakeup sources.
> Add the /sys/power/wake_lock and /sys/power/wake_unlock files
> allowing user space to create, activate and deactivate wakeup
> sources, such that writing a name and optionally a timeout to
> wake_lock causes the wakeup source of that name to be activated,
> optionally with the given timeout.  If that wakeup source doesn't
> exist, it will be created and then activated.  Writing a name to
> wake_unlock causes the wakeup source of that name, if there is one,
> to be deactivated.  Wakeup sources created with the help of
> wake_lock that haven't been used for more than 5 minutes are garbage
> collected and destroyed.  Moreover, there can be only WL_NUMBER_LIMIT

I think it would be better if the garbage collection and limit was
configurable and optional. I would probably turn both features off
since I do not want to chase down bugs because a wakelock was ignored,
and I think the garbage collection will erase stats that we care
about.

-- 
Arve Hjønnevåg
