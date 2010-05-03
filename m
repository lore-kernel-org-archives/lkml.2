Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197Ab0ECWYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 18:24:35 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:50676 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759114Ab0ECWYc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 18:24:32 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1005031810000.1328-100000@iolanthe.rowland.org>
References: <201005032338.26439.rjw@sisk.pl>
	 <Pine.LNX.4.44L0.1005031810000.1328-100000@iolanthe.rowland.org>
Date: Mon, 3 May 2010 15:24:31 -0700
Message-ID: <x2wd6200be21005031524w6c0ef297ka2984fe0740b701b@mail.gmail.com>
Subject: Re: [PATCH 1/8] PM: Add suspend block api.
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Ming Lei <tom.leiming@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 3, 2010 at 3:11 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 3 May 2010, Rafael J. Wysocki wrote:
>
>> The main problem is that the entire suspend subsystem is going to work in a
>> different way when suspend blockers are enforced.  Thus IMO it makes sense to
>> provide a switch between the "opportunistic" and "forced" modes, because that
>> clearly indicates to the user (or user space in general) how the whole suspend
>> subsystem actually works at the moment.
>>
>> As long as it's "opportunistic", the system will autosuspend if suspend
>> blockers are not active and the behavior of "state" reflects that.  If you want
>> to enforce a transition, switch to "forced" first.
>>
>> That's not at all confusing if you know what you're doing.  The defailt mode is
>> "forced", so the suspend subsystem works "as usual" by default.  You have to
>> directly switch it to "opportunistic" to change the behavior and once you've
>> done that, you shouldn't really be surprised that the behavior has changed.
>> That's what you've requested after all.
>
> How about changing the contents of /sys/power/state depending on the
> current policy?  When the policy is "forced" it should look the same as
> it does now.  When the policy is "opportunistic" it should contain
> "mem" and "on".

It already does this.

-- 
Arve Hjønnevåg
