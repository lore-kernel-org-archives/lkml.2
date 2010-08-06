Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935085Ab0HFANl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 20:13:41 -0400
Received: from smtp-out.google.com ([74.125.121.35]:55322 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab0HFANj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 20:13:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=UV0B2e71suKZW4KKhkJtIDzHhoWz/BRXZmg6ZSSiLysiPOyLBPopxDW2taMsWzVI/
	z28cn9RGzvSszirGpcTTA==
MIME-Version: 1.0
In-Reply-To: <20100805230304.GQ2447@linux.vnet.ibm.com>
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
	<20100805230304.GQ2447@linux.vnet.ibm.com>
Date: Thu, 5 Aug 2010 17:13:14 -0700
Message-ID: <AANLkTinatKEBfHhMnKc5wbys13P81PKWSc+nxccgHe-Y@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
From: Brian Swetland <swetland@google.com>
To: paulmck@linux.vnet.ibm.com
Cc: david@lang.hm, kevin granade <kevin.granade@gmail.com>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 4:03 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>> > so what would wake a phone up from suspend where the phone should go back to
>> > sleep in under a second?
>>
>> Here are some real-world examples from shipped android devices:
>> - battery gauging happens every 10 minutes, need to wake long enough
>> to chatter with the 1w interface and make sure the battery is not
>> exploding
>> - always on mail/im/calendar/etc sync often has network events that
>> happen every 5-10 minutes which cause devices to briefly wake up and
>> return to sleep
>> - gps tracker app might wake every couple minutes or every n gps
>> events to log location
>> - low power audio subsystems can wake you up every 1-4 seconds (pcm)
>> or 1-4 minutes (mp3) to fetch more data
>
> Interesting!
>
> So for an mp3 playback, does an Android suspend between data fetches?

It can if the latency is long enough (which is why I point out low
power audio which is usually high latency).  For low latency (system
sounds, etc) 10-25ms between buffers it's not practical to fully
suspend but we will go to the lowest power state in idle if possible.

Brian
