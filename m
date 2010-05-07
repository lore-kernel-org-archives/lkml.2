Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576Ab0EGVcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 17:32:47 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53990 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758459Ab0EGVcm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 17:32:42 -0400
MIME-Version: 1.0
In-Reply-To: <20100507212556.GQ387@atomide.com>
References: <20100507182824.GA25198@srcf.ucam.org>
	 <20100507184621.GA25978@srcf.ucam.org>
	 <1273259186.3542.93.camel@c-dwalke-linux.qualcomm.com>
	 <20100507192837.GM387@atomide.com>
	 <20100507193353.GA27175@srcf.ucam.org>
	 <20100507195548.GN387@atomide.com>
	 <20100507202859.GA27328@srcf.ucam.org>
	 <20100507205329.GP387@atomide.com>
	 <20100507210304.GA28701@srcf.ucam.org>
	 <20100507212556.GQ387@atomide.com>
Date: Fri, 7 May 2010 14:32:41 -0700
Message-ID: <q2zd6200be21005071432iab510d09v8407be18cb97b1ea@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
       markgross@thegnar.org, Brian Swetland <swetland@google.com>,
       linux-doc@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 7, 2010 at 2:25 PM, Tony Lindgren <tony@atomide.com> wrote:
> * Matthew Garrett <mjg@redhat.com> [100507 13:58]:
>> On Fri, May 07, 2010 at 01:53:29PM -0700, Tony Lindgren wrote:
>>
>> > So for example, if I leave ping running in a a terminal, do you
>> > have some way of preventing that from eating the battery?
>>
>> It depends on policy. If all network packets generate wakeup events then
>> no, that will carry on eating battery. If ICMP doesn't generate a wakeup
>> event then the process won't be run.
>>
>> > Do you just suspend the whole system anyways at some point,
>> > or do you have some other trick?
>>
>> If nothing's holding any suspend blocks then the system will enter
>> suspend. If the packet generates a wakeup then the kernel would block
>> suspend until userspace has had the opportunity to do so. Once userspace
>> has handled the packet then it could release the block and the system
>> will immediately transition back into suspend.
>
> OK, then what would I need to do to keep that ping running if I wanted to?
>

Use a suspend blocker. For instance: "runsuspendblock ping <addr>".

>> Here's a different example. A process is waiting for a keypress, but
>> because it's badly written it's also drawing to the screen at 60 frames
>> per second and preventing the system from every going to idle. How do
>> you quiesce the system while still ensuring that the keypress will be
>> delivered to the application?
>
> I guess it depends. If it's a game and I'm waiting to hit the fire
> button, then I don't want the system to suspend!
>

We don't suspend while the screen is on. If the user pressed the power
button to turn the screen off, then I would not want the game to
prevent suspend.

> It's starting to sound like you're really using suspend blocks
> to "certify" that the app is safe to keep running.
>
> Maybe it could be done with some kind of process flag instead that
> would tell "this process is safe to keep running from timer point of view"
> and if that flag is not set, then assume it's OK to stop the process
> at any point?
>
> Regards,
>
> Tony
> _______________________________________________
> linux-pm mailing list
> linux-pm@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/linux-pm
>



-- 
Arve Hjønnevåg
