Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab1BWNtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 08:49:13 -0500
Received: from smtprelay02.ispgateway.de ([80.67.31.25]:47228 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab1BWNtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 08:49:12 -0500
Message-ID: <4D6510A2.1080500@ladisch.de>
Date: Wed, 23 Feb 2011 14:50:26 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Arthur Marsh <arthur.marsh@internode.on.net>, Mel Gorman <mel@csn.ul.ie>
CC: Andrea Arcangeli <aarcange@redhat.com>, alsa-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [Alsa-user] new source of MIDI playback slow-down identified
 - 5a03b051ed87e72b959f32a86054e1142ac4cf55 thp: use compaction in kswapd
 for GFP_ATOMIC order > 0
References: <g0ia38-jj6.ln1@ppp121-45-136-118.lns11.adl6.internode.on.net> <4D6367B3.9050306@googlemail.com> <20110222134047.GT13092@random.random> <20110222161513.GC13092@random.random> <4D63F6C0.7060204@internode.on.net> <20110222194325.GE31195@random.random> <20110223091532.GJ15652@csn.ul.ie> <4D64F26D.1050803@internode.on.net>
In-Reply-To: <4D64F26D.1050803@internode.on.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arthur Marsh wrote:
> Mel Gorman wrote, on 23/02/11 19:45:
> > Unfortunately the original mail is a bit light on details on how this was
> > reproduced and I didn't find a thread with more details. It looks like it's
> > simply playing a midi file while the system is under load but less clear
> > on what the symptoms are (audio skipping maybe?).

The synthesizer hardware continues to generate sound even if the
computer does not update its settings, it's just that the timings are
off.  Even a few milliseconds of jitter are audible.

> > I'll start with using irqs-off tracer to see can I replicate
> > a similar style of issue without depending on sound.
> 
> Clemens, would this work to identify the problem without relying on a 
> device such as a sound card with a wavetable synthesiser or external 
> synthesiser receiving MIDI signals from the pc?

Yes (assuming that it is indeed delayed interrupts that cause the
slowdowns, but I see no other mechanism how memory compaction could
affect the sequencer timer).  Any other job with realtime constraints
should be similarly affected, but the tracer measures the problem
directly at its source.


Regards,
Clemens
