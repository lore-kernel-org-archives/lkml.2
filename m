Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab0FDI4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 04:56:35 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:61491 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab0FDI4d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 04:56:33 -0400
MIME-Version: 1.0
In-Reply-To: <20100604083423.GD15181@elte.hu>
References: <20100603193045.GA7188@elte.hu>
	<20100603231153.GA11302@elte.hu>
	<20100603232302.GA16184@elte.hu>
	<AANLkTikZP3bmckpfb_jUdG7qZO5W9DgpZ79ugtSZaEpt@mail.gmail.com>
	<20100604071354.GA14451@elte.hu>
	<AANLkTimH4ihf3QqtKFpfGXRKtO55PrUuff9JYtaEBG44@mail.gmail.com>
	<20100604083423.GD15181@elte.hu>
Date: Fri, 4 Jun 2010 01:56:33 -0700
Message-ID: <AANLkTinQyzzeF-NOAjrAqqQXqKjFJhx85nI4uyBGRtWd@mail.gmail.com>
Subject: Re: suspend blockers & Android integration
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: tytso@mit.edu, Brian Swetland <swetland@google.com>,
       Neil Brown <neilb@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 4, 2010 at 1:34 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Arve Hj?nnev?g <arve@android.com> wrote:
>
>> > [...]
>> >
>> > Why do you need to track input wakeups? It's rather fragile and rather
>> > unnecessary [...]
>>
>> Because we have keys that should always turn the screen on, but the problem
>> is not specific to input events. If we enabled a wakeup event it usually
>> means we need this event to always work, not just when the system is fully
>> awake or fully suspended.
>
> Hm, i cannot follow that generic claim. Could you please point out the problem
> to me via a specific example? Which task does what, what undesirable thing
> happens where, etc.
>

We have many wakeup events, and some of them are invisible to the
user. For instance on the Nexus One wake up every 10 minutes monitor
the battery health. If the user presses a key right after this work
has finished and we did not block suspend until userspace could
process this key event, we risk suspending before we could turn the
screen on, which to the user looks like the key did not work. Another
example, the user pressed the power key which turns the screen off and
allows suspend. We initiate suspend and a phone call comes in. If we
don't block suspend until we processed the incoming phone call
notification, the phone may never ring (some devices will send a new
message every few seconds for this, so on those devices it would just
delay the ringing).

-- 
Arve Hjønnevåg
