Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567Ab0HEA1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 20:27:40 -0400
Received: from mail.lang.hm ([64.81.33.126]:50588 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007Ab0HEA1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 20:27:37 -0400
Date: Wed, 4 Aug 2010 17:25:53 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <20100805001716.GO24163@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1008041722060.6545@asgard.lang.hm>
References: <20100804185520.GA2417@srcf.ucam.org> <201008042251.08266.rjw@sisk.pl> <20100804205654.GA4986@srcf.ucam.org> <alpine.DEB.2.00.1008041529530.6545@asgard.lang.hm> <AANLkTimRZc2B1=ic-0jrGBX7ahCu=NCoQadCOePGDmh9@mail.gmail.com>
 <alpine.DEB.2.00.1008041554580.6545@asgard.lang.hm> <AANLkTingom2AKfMu0EbfdfLiMnHo+buy1e4=PBENf3Vi@mail.gmail.com> <alpine.DEB.2.00.1008041620010.6545@asgard.lang.hm> <20100804233013.GN24163@linux.vnet.ibm.com> <alpine.DEB.2.00.1008041643490.6545@asgard.lang.hm>
 <20100805001716.GO24163@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Aug 2010, Paul E. McKenney wrote:

> On Wed, Aug 04, 2010 at 04:49:22PM -0700, david@lang.hm wrote:
>> On Wed, 4 Aug 2010, Paul E. McKenney wrote:
>>
>>> On Wed, Aug 04, 2010 at 04:23:43PM -0700, david@lang.hm wrote:
>>>> On Wed, 4 Aug 2010, Arve Hj?nnev?g wrote:
>>>>
>>>>>
>>>>> We suspend as soon as no wakelocks are held. There is no delay.
>>>>
>>>> So, if I have a bookreader app that is not allowed to get the
>>>> wakelock, and nothing else is running, the system will suspend
>>>> immediatly after I click a button to go to the next page? it will
>>>> not stay awake to give me a chance to read the page at all?
>>>>
>>>> how can any application run without wakelock privilages?
>>>
>>> Isn't a wakelock held as long as the display is lit, so that the
>>> system would continue running as long as the page was visible?
>>
>> what holds this wakelock, and what sort of timeout does it have?
>> (and why could that same timeout be used in other ways instead)
>
> I defer to the Android guys on what exactly holds the display's
> wakelock.  The timeout is the display-blank timeout.
>
>> how many apps really need to keep running after the screen blanks?
>> there are a few (audio output apps, including music player and
>> Navigation directions), but I don't have see a problem with them
>> being marked as the 'trusted' apps to pay attention instead.
>
> Downloading is another.

this is definantly an interesting case, do you want an active network 
connection to keep the machine awake? if so do you want it for all network 
connections, or only for some...

> The music player is an interesting example.  It would be idle most
> of the time, given that audio output doesn't consume very much CPU.
> So you would not want to suspend the system just because there were
> no runnable processes.  In contrast, allowing the music player to
> hold a wake lock lets the system know that it would not be appropriate
> to suspend.
>
> Or am I misunderstanding what you are proposing?

the system would need to be idle for 'long enough' (configurable) before 
deciding to suspend, so as long as 'long enough' is longer than the music 
player is idle this would not be a problem.

>> if the backlight being on holds the wakelock, it would seem that
>> almost every other use of the wakelock could (and probably should)
>> be replaced by something that tickles the display to stay on longer.
>
> The problem with this approach is that the display consumes quite a
> bit of power, so you don't want to leave it on unnecessarily.  So if
> the system is doing something (for example, playing music) that does
> not require the display, you really want the display to be off.

what percentage (and types) of apps are really useful with the display 
off. I think that there are relativly few apps that you really want to 
keep running if the display is off.

David Lang
