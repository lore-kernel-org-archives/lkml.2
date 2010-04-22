Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab0DVNuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 09:50:54 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44347 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab0DVNux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 09:50:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=V7ll4ntAwi18pZvJ37eBrC2Aj7ndQqNliT5hkKXYhpcbv3uWw83SIkp2B8gR+r3lzN
         KQa2PTCm8Encce7aeIHVFJBw5DeXioSDBd7Jku4lpwxWkYtcwyhIDNy5YyFT2zWAW+/4
         dmG3Hvn9XbA6ukob6rni+GenTE9LpB/SPQfPQ=
MIME-Version: 1.0
In-Reply-To: <1271942430.10448.196.camel@gandalf.stny.rr.com>
References: <s2uc5b2c05b1004191348p517c8ac4z32104ea91dd1ca67@mail.gmail.com>
	 <1271804453.10448.168.camel@gandalf.stny.rr.com>
	 <t2nc5b2c05b1004202216pd159c9b4mbfc1dc7658fc20e7@mail.gmail.com>
	 <1271839772.1776.58.camel@laptop>
	 <1271854016.10448.172.camel@gandalf.stny.rr.com>
	 <x2mc5b2c05b1004211224s7825933dh531f2ed030610e9e@mail.gmail.com>
	 <1271879833.1776.186.camel@laptop>
	 <s2tc5b2c05b1004211338y814bc3b2o547a6eecdf64ca7f@mail.gmail.com>
	 <1271883496.1776.263.camel@laptop>
	 <1271942430.10448.196.camel@gandalf.stny.rr.com>
Date: Thu, 22 Apr 2010 15:50:52 +0200
Message-ID: <x2hc5b2c05b1004220650w53919f62hf3daedb822755bf4@mail.gmail.com>
Subject: Re: Considerations on sched APIs under RT patch
From: Primiano Tucci <p.tucci@gmail.com>
To: rostedt@goodmis.org
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       tglx <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's been a while since I've used SMP VxWorks, but back then what it did
> was to copy an image for ever CPU separately. It was not really SMP but
> instead a separate OS for each CPU. Things may have changed since then
> (it was around 2002 when I saw this).
>
> There's projects to do the same for Linux, and I feel it may give you
> the most control of the system. But the hardware is still shared, so the
> contention does not go away, it just gets moved to the hardware
> resources.

I knew this kind of solution based on OS-partitioning, but my group
and I are currently working on a Global-EDF scheduler, a unique
scheduler (and therefore a unique OS/Kernel) that is able to migrate
tasks between CPUs in order to maximize the global CPU usage.
In order to to this we have a unique "super"-process (a
Meta-Scheduler) that needs to be able to control priority and affinity
of the managed tasks, without losing the control while doing this.
We are able to make it work under VXWorks 6.7 SMP (that seems to be
really-smp), now we are trying to port the same infrastructure on a
Linux-RT Kernel to compare the performances, but we found the issue
with the sefaffinity syscall as described into my first mail.
I will try to update to the last kernel version and see if it works correctly.

Thanks,
Primiano

--
 Primiano Tucci
 http://www.primianotucci.com
