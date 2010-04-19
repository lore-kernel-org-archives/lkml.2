Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab0DSOpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:45:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:50704 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab0DSOpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:45:41 -0400
Date: Mon, 19 Apr 2010 07:47:22 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: =?UTF-8?B?w4lyaWM=?= Piel <eric.piel@tremplin-utc.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, tglx@linutronix.de, davej@redhat.com,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with
 ondemand during disk IO
Message-ID: <20100419074722.656dc8d6@infradead.org>
In-Reply-To: <4BCC68E8.8080005@tremplin-utc.net>
References: <20100418115949.7b743898@infradead.org>
	<20100418120346.1b478410@infradead.org>
	<4BCC147B.10708@tremplin-utc.net>
	<20100419064325.49cb3108@infradead.org>
	<4BCC68E8.8080005@tremplin-utc.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > on the machines I used this on (Core i7's) it's actually hardly
> > measurable. All CPUs I have access to turn the voltage entirely off
> > during idle, so while the frequency is higher, if you're mostly IO
> > bound, it's only for very short durations... while still being
> > mostly "off".
> Yes, but keep in mind the Linux ondemand governor should not be
> tweaked only for the latest Intel CPUs.

this is not just "latest Intel".  Just about everyone does this.


> I've just done a very little
> and _extremely rough_ measurement on my laptop with a Core Duo 2, and
> while it seems that, indeed, at idle the frequency didn't matter for
> the consumption (about 12.5W with any governor), when running
> updatedb (so IO bound), the performance governor seems to consume
> more than ondemand and powersave (14.8-15.8W instead of 14.0-14.6W).
> I'm very careful with the results of this "experiment" because it's
> only using the ACPI report for the power usage and done with many
> other programs in the background. Nevertheless, it manages to
> convince me that this change is not going to be as harmless for the
> power consumption as you suggest.

be careful; you're measuring power not energy. You also need to take
into account that things are now done quicker, so that you can then be
idle longer later! So yes instantaneous you're using a bit more power
(since you're getting much more performance), but you're done much
quicker as well.... Once you do this the equation changes, and it's
more or less a wash.


As for your general "ondemand is for everyone" concern; there are many
things wrong with ondemand, and I'm writing a new governor to fix the
more fundamental issues with it (and also, frankly, so that I won't
break existing users and hardware I don't have access to). This is
basically a backport of a specific feature of my new governor to
ondemand because Andrew keeps hitting the really bad case and basically
ended up turning power management off.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
