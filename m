Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933991Ab0FFL1g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 07:27:36 -0400
Received: from mail.lang.hm ([64.81.33.126]:55659 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933087Ab0FFL1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 07:27:34 -0400
Date: Sun, 6 Jun 2010 04:26:14 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Felipe Contreras <felipe.contreras@gmail.com>
cc: Arjan van de Ven <arjan@infradead.org>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       tytso@mit.edu, Brian Swetland <swetland@google.com>,
       Neil Brown <neilb@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: suspend blockers & Android integration
In-Reply-To: <AANLkTimjtNhtI0CuxYd0wdN_svthC-vl9_a5abDS2yyo@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.1006060422520.17462@asgard.lang.hm>
References: <20100603193045.GA7188@elte.hu> <20100603231153.GA11302@elte.hu> <20100603232302.GA16184@elte.hu> <AANLkTikZP3bmckpfb_jUdG7qZO5W9DgpZ79ugtSZaEpt@mail.gmail.com> <20100604071354.GA14451@elte.hu> <AANLkTimH4ihf3QqtKFpfGXRKtO55PrUuff9JYtaEBG44@mail.gmail.com>
 <20100604083423.GD15181@elte.hu> <AANLkTinQyzzeF-NOAjrAqqQXqKjFJhx85nI4uyBGRtWd@mail.gmail.com> <1275653210.27810.39762.camel@twins> <AANLkTinyjBa0KYfFz3_EFbC65hoQFwFINlTDYjCe-wM3@mail.gmail.com> <1275731653.27810.41078.camel@twins> <20100605092851.6ee15f13@infradead.org>
 <AANLkTimEwznq9c_8lkuBMxEQ-42rdvpZEqA9Y71Cu-qC@mail.gmail.com> <20100605152326.7ccd5160@infradead.org> <AANLkTimjtNhtI0CuxYd0wdN_svthC-vl9_a5abDS2yyo@mail.gmail.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jun 2010, Felipe Contreras wrote:

> 2010/6/6 Arjan van de Ven <arjan@infradead.org>:
>> On Sat, 5 Jun 2010 14:26:14 -0700
>> Arve Hj?nnev?g <arve@android.com> wrote:
>>>> the kernel has a set of infrastructure already to help here (range
>>>> timers, with which you can wakeup-limit untrusted userspace crap),
>>>> timer slack for legacy background timers, etc etc.
>>>
>>> Range timers allows the kernel to align different timers so they don't
>>> each bring the cpu out of idle individually. They do not eliminate
>>> timers or make individual timers fire less often.
>>
>> you're incorrect.
>> With range timers you can control the rate at which timers fire just
>> fine.
>
> I was wondering... Currently GLib user-space aligns itself to fire
> burst of work at second boundaries without the need for IPC. But if
> you want to align beyond one second you need multi-process alignment.
> Say, one application says: wake me up between 30s and 1m. And the
> other one says: wake me up between 10m and 20m. They could very well
> align at some point if there was a central process keeping track of
> all the timers.
>
> Does the kernel provide something to solve that problem already?

yes,the kernel will let you say 'wake me in 10m, with a possible delay of 
up to 10 min' and get woken up between 10 and 20 min

this is what was mentioned earlier in the thread where you could take an 
app that tries to do something every .1 second and set the kernel to allow 
the tick to be delayed for up to 3.9 seconds, resulting in a wakeup every 
4 seconds if the system is idle. This has the additional advantage that if 
the system is not idle and other things are causing ticks to take place 
anyway, this app would get more ticks up to the 10/second it's asking for)

David Lang
