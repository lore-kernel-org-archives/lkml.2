Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760857Ab2EWVyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 17:54:19 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:49320 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397Ab2EWVyR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 17:54:17 -0400
Date: Wed, 23 May 2012 16:53:59 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Anders =?utf-8?Q?Bostr=C3=B6m?= <anders@netinsight.net>
Cc: linux-kernel@vger.kernel.org,
        =?utf-8?B?TGVzxYJhdyBLb3BlxIc=?= <leslaw.kopec@nasza-klasa.pl>,
        Aman Gupta <aman@tmm1.net>, Doug Smythies <dsmythies@telus.net>
Subject: Re: [3.2.16 -> 3.2.17 regression] High reported CPU load when idle
Message-ID: <20120523215359.GA19798@burratino>
References: <20120523.144057.899060240318474097.anders@netinsight.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20120523.144057.899060240318474097.anders@netinsight.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anders,

Anders Boström wrote[1]:

> Starting with 3.2.17-1, the CPU load accounting is broken when the
> computer is idle. The CPU load is reported as >0.50 when
> idle. 3.2.16-1 don't suffer from this problem.
>
> Suspected patch is the upstream patch
> "sched: Fix nohz load accounting -- again!"
> commit 5e2d50da11f0e6ec3ce8fe658d7c83b0b4346c68 to 3.2 and
> originating from c308b56b5398779cd3da0f62ab26b0453494c3d4 .
>
> See also:
>
> https://bugs.launchpad.net/unity/+bug/991370
> https://lkml.org/lkml/2012/5/22/310
> https://bugzilla.redhat.com/show_bug.cgi?id=822877
> https://bbs.archlinux.org/viewtopic.php?id=141289

Thanks for writing.

If I understand correctly, the load average calculation both before
and after that commit is broken, in different ways.

I'm cc-ing Lesław Kopeć, Aman Gupta, and Doug Smythies who worked
on the above change[2].  I recommend pulling Thomas Gleixner
<tglx@linutronix.de> into the conversation once you have a better
idea of what's going on or a new change to recommend.  If you'd like
to also track this on a bugtracker, http://bugzilla.kernel.org/,
product Process Management, component Scheduler might be a good place.

Aside from that, I can't really offer much to help you, but others
on linux-kernel might.

Hope that helps,
Jonathan

[1] http://bugs.debian.org/674153
[2] http://thread.gmane.org/gmane.linux.kernel/1249223/focus=1262319
[3] http://thread.gmane.org/gmane.linux.kernel/1291870/focus=1292058
