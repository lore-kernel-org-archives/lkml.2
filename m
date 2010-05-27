Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab0E0Xui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 19:50:38 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46638 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab0E0Xuh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 19:50:37 -0400
MIME-Version: 1.0
In-Reply-To: <201005280143.01889.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1005271303190.3239-100000@iolanthe.rowland.org>
	<201005272315.28475.rjw@sisk.pl>
	<alpine.LFD.2.00.1005272334040.3478@localhost.localdomain>
	<201005280143.01889.rjw@sisk.pl>
Date: Thu, 27 May 2010 16:50:36 -0700
Message-ID: <AANLkTinTk6iCgfcY1QaZkCCapYjzbEYgGbSR4Ki75z0R@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 4:43 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday 27 May 2010, Thomas Gleixner wrote:
>> On Thu, 27 May 2010, Rafael J. Wysocki wrote:
>>
>> > On Thursday 27 May 2010, Thomas Gleixner wrote:
>> > > On Thu, 27 May 2010, Alan Stern wrote:
>> > >
>> > > > On Thu, 27 May 2010, Felipe Balbi wrote:
>> > > >
>> > > > > On Thu, May 27, 2010 at 05:06:23PM +0200, ext Alan Stern wrote:
>> > > > > >If people don't mind, here is a greatly simplified summary of the
>> > > > > >comments and objections I have seen so far on this thread:
>> > > > > >
>> > > > > >     The in-kernel suspend blocker implementation is okay, even
>> > > > > >     beneficial.
>> > > > >
>> > > > > I disagree here. I believe expressing that as QoS is much better. Let
>> > > > > the kernel decide which power state is better as long as I can say I
>> > > > > need 100us IRQ latency or 100ms wakeup latency.
>> > > >
>> > > > Does this mean you believe "echo mem >/sys/power/state" is bad and
>> > > > should be removed?  Or "echo disk >/sys/power/state"?  They pay no
>> > >
>> > > mem should be replaced by an idle suspend to ram mechanism
>> >
>> > Well, what about when I want the machine to suspend _regardless_ of whether
>> > or not it's idle at the moment?  That actually happens quite often to me. :-)
>>
>> Fair enough. Let's agree on a non ambigous terminology then:
>>
>>      forced:
>>
>>            suspend which you enforce via user interaction, which
>>            also implies that you risk losing wakeups depending on
>>            the hardware properties
>
> OK
>
>>      opportunistic:
>>
>>            suspend driven from the idle context, which guarantees to
>>            not lose wakeups. Provided only when the hardware does
>>            provide the necessary capabilities.
>
> I can accept that definition, but this is not what "opportunistic" means in the

Is there a difference between this new definition of opportunistic and
idle? I assume suspend here means low a low power sleep state since it
is impossible to initiate and abort Linux suspend from idle since
initiating suspend will cause the system to become not idle.

> Arve's changelogs.  What it means there is that he wants the system to suspend
> even when it is not technically idle (like in the updatedb example I gave in a
> previous message).  Suspend blockers are supposed to be a mechanism by which
> the kernel and user space together may determine when to suspend (and it's
> somewhat orthogonal to idle).
>



-- 
Arve Hjønnevåg
