Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752Ab0HLBDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 21:03:12 -0400
Received: from smtp-out.google.com ([74.125.121.35]:22197 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758697Ab0HLBDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 21:03:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=mG0CI8wiRXxH5SP3gJpVmTFoJonxH3qroo7qXvgeW35Gmqag8dnU09iOqKLTLIQ+Z
	MRGXuFfHc97zVxIGQreMA==
MIME-Version: 1.0
In-Reply-To: <AANLkTinWmZZHd6uRRY-RRj_qu5P-3BjY8LRWrpRwFncH@mail.gmail.com>
References: <20100806225453.GA3947@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008061651530.30564@asgard.lang.hm>
	<AANLkTikyRhtfX4R3x_NDgHnXssmfVuhjC5PbhRZ0a7su@mail.gmail.com>
	<alpine.DEB.2.00.1008062010510.30564@asgard.lang.hm>
	<20100807061558.GA28087@thunk.org>
	<AANLkTi=sMVjya9CH6UoZwJCXJTDRgBhnPXmApU_RHVTi@mail.gmail.com>
	<20100808155719.GB3635@thunk.org>
	<AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com>
	<20100808213821.GD3635@thunk.org>
	<AANLkTinNc1SWmz8pE_4k6vThxQCJfCR_UqV6OM=OsJOf@mail.gmail.com>
	<20100811193106.GB24435@thunk.org>
	<AANLkTinBrp1iHWAi=vk_eaEHMs+Xcub6rg8PgT_LK2c9@mail.gmail.com>
	<AANLkTinOb5PsrLbMzbYVqqx=6n-yPNRCYgOf4fM5KdXJ@mail.gmail.com>
	<AANLkTimAKwDPYZeCj_UEyXf-6DxLg8=Zi-=tFKzzgvQi@mail.gmail.com>
	<AANLkTimwdJgAUHNgUDwagDhBd2MtEoSbt7rFa2dPkm2c@mail.gmail.com>
	<AANLkTinWmZZHd6uRRY-RRj_qu5P-3BjY8LRWrpRwFncH@mail.gmail.com>
Date: Wed, 11 Aug 2010 18:03:00 -0700
Message-ID: <AANLkTikxRsggbUKRnPXh5pnaP8M7iTXBunNt4BDUZbyF@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Brian Swetland <swetland@google.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, david@lang.hm,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk,
        menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
        arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
        dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 5:46 PM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> On Thu, Aug 12, 2010 at 1:12 AM, Brian Swetland <swetland@google.com> wrote:
>> On Wed, Aug 11, 2010 at 3:03 PM, Felipe Contreras
>> <felipe.contreras@gmail.com> wrote:
>>> This is what I'm talking about when I say multi-tasking, Android
>>> certainly doesn't have anything remotely like that:
>>> http://www.youtube.com/watch?v=7emvUBpEkbU
>>
>> Home + pick app -> switch to the app in whatever state it was in.
>
> If the app stops running, that's *fake* multi-tasking, and doesn't
> match my experience; I can't remember the details, but I tested it on
> a Nexus One, and the item I was looking at was gone, I had to scroll
> again.

That'd be surprise.  Last I checked I was able to launch 40-50 apps on
N1 before we even started getting low on memory and the system won't
kill apps off unless we completely bottom out on memory.  It's
possible that some app might do the wrong thing when going to the
background and back to the foreground but that'd be an app bug.

> Also, I cannot go to last.fm on the browser, play some music, and do
> other stuff at the same time, can I?

I'm not sure off the top of my head if the browser will keep
music/flash playing on pages when it's not the foreground app, but you
can certainly run something like Pandora (or a number of other
streaming music apps) in the background and play streaming music while
you do other stuff.  There's no reason the browser *couldn't* do this
as well.

> Anyway, what you do in Android is your problem. The point is that in
> Linux we need good PM *with* multi-tasking (not really an argument
> against opportunistic suspend, I think, but a clarification from Ted's
> comment)

Well I'm glad we agree that multitasking and PM are important.

Brian
