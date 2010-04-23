Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab0DWIrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 04:47:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60770 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768Ab0DWIrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 04:47:31 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with ondemand during disk IO
Date: Fri, 23 Apr 2010 10:50:10 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, tglx@linutronix.de, davej@redhat.com,
       cpufreq@vger.kernel.org
References: <20100418115949.7b743898@infradead.org> <20100423052439.GB4829@ucw.cz> <20100423053858.GE7798@1wt.eu>
In-Reply-To: <20100423053858.GE7798@1wt.eu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004231050.10667.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 April 2010 07:38:58 Willy Tarreau wrote:
> On Fri, Apr 23, 2010 at 07:24:39AM +0200, Pavel Machek wrote:
> > Hi!
> > 
... 
> > > This patch changes the ondemand algorithm to count iowait time as busy,
> > > not idle, time. As shown in the breakdown cases above, iowait is performance
> > > critical often, and by counting iowait, the proxy variable becomes a more
> > > accurate representation of the "how critical is performance"
> > > question.
> > 
> > Well, and now, if you do something like cat /dev/<your usb1.1 hdd> >
> > /dev/null, you'll keep cpu on max frequency. Not a problem for new
> > core i7, but probably big deal for athlon 64.
> 
> So that also means that my notebook's CPU fan will spin like mad as soon
> as I access a USB key ? It will not help the key go faster...
> 
> Probably that iowait should only change the time required to go back to
> low frequency. That way, if there is no CPU nor I/O activity, we can
> switch back to a low frequency quickly, but if we see I/O activity, we
> could decide to wait for 1 second (for instance)
that sounds wrong.
> for CPU idle before switching back to low frequency.
I'd just make this decission (consider IO time yes/no) configurable.
A userspace daemon/app could then e.g. switch when on battery, AC, if
it's a laptop in general or if user switched to a silent/powersave mode
when being in a library.
It may be more efficient to ramp the freq up during the whole IO process and
this is crucial in the server area, but most laptop/desktop users are happy
as long as the data for their video/audio stream is fetched from the device
quickly enough for displaying.
Especially on battery, users will appreciate some minutes of more battery
lifetime and do not care about some ms of IO latencies.
You would cut of this elementary cpufreq feature for the ondemand governor
with these patches.

    Thomas
