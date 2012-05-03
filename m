Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886Ab2ECWOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 18:14:15 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64033 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469Ab2ECWON convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 18:14:13 -0400
MIME-Version: 1.0
In-Reply-To: <201205032129.41611.rjw@sisk.pl>
References: <201202070200.55505.rjw@sisk.pl>
	<CAMP5Xgeq2y+dcifY7tkuQVgUSpzrLHXsPpHBq+7zu=mE+wD0Ng@mail.gmail.com>
	<201204272334.04387.rjw@sisk.pl>
	<201205032129.41611.rjw@sisk.pl>
Date: Thu, 3 May 2012 15:14:12 -0700
Message-ID: <CAMP5XgdC6Tzhxi4kD7XgDqptY3D4ykfFyvEyAOtKhHTW8rFCwg@mail.gmail.com>
Subject: Re: [PATCH 0/2]: Kconfig options for wakelocks limit and gc (was: Re:
 [RFC][PATCH 8/8] PM / Sleep: Add user space ...)
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

On Thu, May 3, 2012 at 12:29 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, April 27, 2012, Rafael J. Wysocki wrote:
>> On Friday, April 27, 2012, Arve Hjønnevåg wrote:
>> > 2012/4/27 Rafael J. Wysocki <rjw@sisk.pl>:
>> > > On Friday, April 27, 2012, Arve Hjønnevåg wrote:
>> > >> 2012/4/26 Rafael J. Wysocki <rjw@sisk.pl>:
>> > >> ...
>> > >> > ---
>> > >> > From: Rafael J. Wysocki <rjw@sisk.pl>
>> > >> > Subject: PM / Sleep: Add user space interface for manipulating wakeup sources, v3
>> > >> >
>> > >> > Android allows user space to manipulate wakelocks using two
>> > >> > sysfs file located in /sys/power/, wake_lock and wake_unlock.
>> > >> > Writing a wakelock name and optionally a timeout to the wake_lock
>> > >> > file causes the wakelock whose name was written to be acquired (it
>> > >> > is created before is necessary), optionally with the given timeout.
>> > >> > Writing the name of a wakelock to wake_unlock causes that wakelock
>> > >> > to be released.
>> > >> >
>> > >> > Implement an analogous interface for user space using wakeup sources.
>> > >> > Add the /sys/power/wake_lock and /sys/power/wake_unlock files
>> > >> > allowing user space to create, activate and deactivate wakeup
>> > >> > sources, such that writing a name and optionally a timeout to
>> > >> > wake_lock causes the wakeup source of that name to be activated,
>> > >> > optionally with the given timeout.  If that wakeup source doesn't
>> > >> > exist, it will be created and then activated.  Writing a name to
>> > >> > wake_unlock causes the wakeup source of that name, if there is one,
>> > >> > to be deactivated.  Wakeup sources created with the help of
>> > >> > wake_lock that haven't been used for more than 5 minutes are garbage
>> > >> > collected and destroyed.  Moreover, there can be only WL_NUMBER_LIMIT
>> > >>
>> > >> I think it would be better if the garbage collection and limit was
>> > >> configurable and optional. I would probably turn both features off
>> > >> since I do not want to chase down bugs because a wakelock was ignored,
>> > >> and I think the garbage collection will erase stats that we care
>> > >> about.
>> > >
>> > > OK, but would you mind if I added the configurability as a separate incremental
>> > > patch?
>> > >
>> >
>> > That is fine with me.
>>
>> Cool, thanks!
>
> The following two patches add the configuration options for the limit and
> garbage collector.  Please let me know if they are OK with you.
>

Yes.

-- 
Arve Hjønnevåg
