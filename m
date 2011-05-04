Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab1EDTKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 15:10:09 -0400
Received: from trent.utfs.org ([194.246.123.103]:45188 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941Ab1EDTKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 15:10:07 -0400
Date: Wed, 4 May 2011 12:10:04 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Dave Chinner <david@fromorbit.com>
cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        minchan.kim@gmail.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <20110504111211.GF9114@dastard>
Message-ID: <alpine.DEB.2.01.1105041205340.18728@trent.utfs.org>
References: <20110429201701.GA13166@x4.trippels.de> <alpine.DEB.2.01.1104291710340.18728@trent.utfs.org> <20110501080149.GD13542@dastard> <alpine.DEB.2.01.1105012135260.18728@trent.utfs.org> <20110502121958.GA2978@dastard> <alpine.DEB.2.01.1105021247410.18728@trent.utfs.org>
 <20110503005114.GE2978@dastard> <alpine.DEB.2.01.1105031345090.18728@trent.utfs.org> <alpine.DEB.2.01.1105031740460.18728@trent.utfs.org> <20110504073615.GD9114@dastard> <20110504111211.GF9114@dastard>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011 at 21:12, Dave Chinner wrote:
>> Ok, that will be helpful. Also helpful is that I've (FINALLY!)
>> reproduced this myself, and i think i can now reproduce it at will
>> on a highmem i686 machine. I'll look into it more later tonight....

I've tried to reproduce it on an SMP i686 with 1024MB RAM, but there was 
no OOM there.

> And here's a patch for you to try. It fixes the problem on my test
> machine.....

Excellent! After one run with that patch, the machine does not go OOM any 
more when running du(1) over this XFS filesystem.

I've run du(1) login with my oom-debug script to gather sysrq-w and 
slabinfo, see https://trent.utfs.org/p/bits/2.6.39-rc4/oom/trace/16-* for 
the details.

I'll poke it a bit more over the day, but your patch (one line only! Wow!) 
seems to help.

Thanks so much,
Christian.
-- 
BOFH excuse #160:

non-redundant fan failure
