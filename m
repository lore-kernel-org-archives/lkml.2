Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934899Ab0HEXDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 19:03:12 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:39413 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755831Ab0HEXDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 19:03:08 -0400
Date: Thu, 5 Aug 2010 16:03:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Brian Swetland <swetland@google.com>
Cc: david@lang.hm, kevin granade <kevin.granade@gmail.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100805230304.GQ2447@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.2.00.1008041722060.6545@asgard.lang.hm>
 <20100805004802.GP24163@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008042208350.25170@asgard.lang.hm>
 <20100805151211.GA10080@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008050832010.25170@asgard.lang.hm>
 <AANLkTi=Yyyc-hOPbkJtsnKCVzncnFq8DPnonmyckekwm@mail.gmail.com>
 <20100805203102.GN2447@linux.vnet.ibm.com>
 <AANLkTimaaLSwVusJ=w5-QptoauBnHH0JvCvmWUr0y+KD@mail.gmail.com>
 <alpine.DEB.2.00.1008051453450.30632@asgard.lang.hm>
 <AANLkTikCCeMG=DAQ04xqkvqH9tngBWyBA5VQTD4_15xU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikCCeMG=DAQ04xqkvqH9tngBWyBA5VQTD4_15xU@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 03:16:51PM -0700, Brian Swetland wrote:
> On Thu, Aug 5, 2010 at 3:09 PM,  <david@lang.hm> wrote:
> >> Oops, yea that's actually a really bad example, that's probably
> >> something that would be handled by low-power states.  I think the
> >> incoming text message example is a good one though.  There seemed to
> >> be a focus on user-interaction scale time scales, and I wanted to
> >> point out that there are also very short duration time scales to
> >> consider as well.
> >
> > good point, but I do think the short time scales are less common than people
> > think.
> >
> > I'd love to get good examples of them
> >
> > on my iphone when a text message arrives the phone displays an alert for
> > user-interaction times (it even lights the display to show who the message
> > is from, and optionally a preview of the message)
> >
> > so what would wake a phone up from suspend where the phone should go back to
> > sleep in under a second?
> 
> Here are some real-world examples from shipped android devices:
> - battery gauging happens every 10 minutes, need to wake long enough
> to chatter with the 1w interface and make sure the battery is not
> exploding
> - always on mail/im/calendar/etc sync often has network events that
> happen every 5-10 minutes which cause devices to briefly wake up and
> return to sleep
> - gps tracker app might wake every couple minutes or every n gps
> events to log location
> - low power audio subsystems can wake you up every 1-4 seconds (pcm)
> or 1-4 minutes (mp3) to fetch more data

Interesting!

So for an mp3 playback, does an Android suspend between data fetches?

							Thanx, Paul
