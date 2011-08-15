Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab1HOIh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 04:37:28 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:50414 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab1HOIhZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 04:37:25 -0400
MIME-Version: 1.0
In-Reply-To: <1312196702.2617.445.camel@laptop>
References: <CAC9WiBgbhLomH_CtLGKyxm2xD9=h1nJAy=-b24GOaUV+hg7bNg@mail.gmail.com>
	<20110731110641.GG2209@sun>
	<CAC9WiBgg+To8ggUvTqxOCy2hgb=XQCRH6D_0HFy4sEEoF8R0rw@mail.gmail.com>
	<20110731153225.GJ2209@sun>
	<1312196702.2617.445.camel@laptop>
Date: Mon, 15 Aug 2011 10:37:24 +0200
Message-ID: <CAC9WiBitmuvZOS74UY1E-=y+6hpm6_OgaR9E6wrHhdvARt2uJA@mail.gmail.com>
Subject: Re: v3.0: Weird kernel log message when resuming avout NMI received
From: Francis Moreau <francis.moro@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>, Stephane Eranian <eranian@google.com>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter,

Sorry for the loooonnng delay but summer rest :)

On Mon, Aug 1, 2011 at 1:05 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Sun, 2011-07-31 at 19:32 +0400, Cyrill Gorcunov wrote:
>
>> > >> I'm seeing those kernel message when resuming:
>> > >>
>> > >> [  524.973283] Uhhuh. NMI received for unknown reason 3d on CPU 0.
>> > >> [  524.973288] Do you have a strange power saving mode enabled?
>> > >> [  524.973289] Dazed and confused, but trying to continue
>> > >>
>> > >> I don't know if it's important or not because the system seems to work
>> > >> after but maybe it worths to report
>
> So I guess the problem is the NMI watchdog and suspend stuff not
> shutting things down properly..
>
> Argh, the PM notifier muck runs before the hotplug notifiers and it
> doesn't avoid hotplug races on its own.. what crap.
>
> something like the below perhaps, compile tested only.. does it work?

Thanks for the fix, I'm going to give it a test and report in 2 days.

-- 
Francis
