Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760046Ab0HEWQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:16:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12277 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758573Ab0HEWQ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:16:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=jpU+9nXx7R0pQDMCQR1+lfjKT0IrEjB+X6OTOrsAIP9ygJ5ZofzbekqwsdqKshMXv
	LEpVNs4rnGHw3d4qNIfwg==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1008051453450.30632@asgard.lang.hm>
References: <alpine.DEB.2.00.1008041620010.6545@asgard.lang.hm>
	<20100804233013.GN24163@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008041643490.6545@asgard.lang.hm>
	<20100805001716.GO24163@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008041722060.6545@asgard.lang.hm>
	<20100805004802.GP24163@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008042208350.25170@asgard.lang.hm>
	<20100805151211.GA10080@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008050832010.25170@asgard.lang.hm>
	<AANLkTi=Yyyc-hOPbkJtsnKCVzncnFq8DPnonmyckekwm@mail.gmail.com>
	<20100805203102.GN2447@linux.vnet.ibm.com>
	<AANLkTimaaLSwVusJ=w5-QptoauBnHH0JvCvmWUr0y+KD@mail.gmail.com>
	<alpine.DEB.2.00.1008051453450.30632@asgard.lang.hm>
Date: Thu, 5 Aug 2010 15:16:51 -0700
Message-ID: <AANLkTikCCeMG=DAQ04xqkvqH9tngBWyBA5VQTD4_15xU@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
From: Brian Swetland <swetland@google.com>
To: david@lang.hm
Cc: kevin granade <kevin.granade@gmail.com>, paulmck@linux.vnet.ibm.com,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 3:09 PM,  <david@lang.hm> wrote:
>> Oops, yea that's actually a really bad example, that's probably
>> something that would be handled by low-power states.  I think the
>> incoming text message example is a good one though.  There seemed to
>> be a focus on user-interaction scale time scales, and I wanted to
>> point out that there are also very short duration time scales to
>> consider as well.
>
> good point, but I do think the short time scales are less common than people
> think.
>
> I'd love to get good examples of them
>
> on my iphone when a text message arrives the phone displays an alert for
> user-interaction times (it even lights the display to show who the message
> is from, and optionally a preview of the message)
>
> so what would wake a phone up from suspend where the phone should go back to
> sleep in under a second?

Here are some real-world examples from shipped android devices:
- battery gauging happens every 10 minutes, need to wake long enough
to chatter with the 1w interface and make sure the battery is not
exploding
- always on mail/im/calendar/etc sync often has network events that
happen every 5-10 minutes which cause devices to briefly wake up and
return to sleep
- gps tracker app might wake every couple minutes or every n gps
events to log location
- low power audio subsystems can wake you up every 1-4 seconds (pcm)
or 1-4 minutes (mp3) to fetch more data

Brian
