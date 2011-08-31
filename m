Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab1HaOFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 10:05:10 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64448 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab1HaOFF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 10:05:05 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <1314786377.4653.19.camel@marge.simson.net>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	<CAOtvUMdgPoL_gnOTq8DwS9RxSFagQN_kAze3guD8O3xFHfnfHg@mail.gmail.com>
	<20110830140648.GL9748@somewhere.redhat.com>
	<1314762442.4653.5.camel@marge.simson.net>
	<1314782887.23993.12.camel@twins>
	<1314786377.4653.19.camel@marge.simson.net>
Date: Wed, 31 Aug 2011 17:05:02 +0300
Message-ID: <CAOtvUMdWu9KUk+ZxOcwEucJ2DHqKEQLuJFpMj1qYkuOeCb=OEQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/32] Nohz cpusets (was: Nohz Tasks)
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Guess I'll have to try creating a cpuset per cpu, and see how it
> compares to isolcpus.  cset shield --cpu 4-63 didn't work well enough.

Try adding:

# cset shield --kthread on

It will try to move non bound kernel threads to the system set from
the root set.

The results seems to vary from introducing system instability, via
doing nothing at all, all the way to actually achieving better
isolation, depending on the specific kernel threads you have running
and your kernel version. Sometime more then one of the results at the
same time. It's really like Russian roulette in a way, only way more
geekier...

-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com
"Dance like no one is watching, love like you'll never be hurt, sing
like no one is listening... but for BEEP sake you better code like
you're going to maintain it for years!"
