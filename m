Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762198Ab0HGDPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 23:15:30 -0400
Received: from mail.lang.hm ([64.81.33.126]:43031 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab0HGDP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 23:15:29 -0400
Date: Fri, 6 Aug 2010 20:14:09 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Brian Swetland <swetland@google.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk,
        menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
        tytso@mit.edu, arjan@infradead.org, swmike@swm.pp.se,
        galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
In-Reply-To: <AANLkTikyRhtfX4R3x_NDgHnXssmfVuhjC5PbhRZ0a7su@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1008062010510.30564@asgard.lang.hm>
References: <20100731175841.GA9367@linux.vnet.ibm.com> <20100804195704.GA23681@linux.vnet.ibm.com> <20100806225453.GA3947@linux.vnet.ibm.com> <alpine.DEB.2.00.1008061651530.30564@asgard.lang.hm>
 <AANLkTikyRhtfX4R3x_NDgHnXssmfVuhjC5PbhRZ0a7su@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Aug 2010, Brian Swetland wrote:

> On Fri, Aug 6, 2010 at 4:59 PM,  <david@lang.hm> wrote:
>>
>> now, android is betting that the apps are all developed specifically for the
>> android from scratch, so having a different API is acceptable, even if it
>> cuts them off from the rest of the *nix applications. For a phone this is
>> not neccessarily an unreasonable stance, but as Android moves into the
>> spaces where normal applications are in use (netbooks and tablets), this
>> becomes a much shakier stance to take.
>
> "Normal" apps work reasonably well -- they get halted when the screen
> turns off, just like they do when my laptop suspends.
>
> Wakelocks are useful for mobile-centric apps that you want to keep
> running in the background, wake up and do work when the device is
> "asleep", etc.

that description sounds far more like normal sleep power management that 
suspending. especially since they want to set timers to wake the system up 
and the defining characteristic of suspend (according to this thread) is 
that timers don't fire while suspended.

as I am seeing it, there are two reasons why this don't "just work"

1. sleeping can't currently save as much power as suspending

2. the current logic for deciding to sleep can't ignore the other apps on 
the system.

David Lang
