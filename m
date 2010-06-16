Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816Ab0FPOhK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 10:37:10 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:37466 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753874Ab0FPOhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 10:37:08 -0400
Date: Wed, 16 Jun 2010 10:36:59 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: David Howells <dhowells@redhat.com>, tytso@mit.edu,
       Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Why is kslowd accumulating so much CPU time?
Message-ID: <20100616143659.GA14616@elliptictech.com>
Mail-Followup-To: Andy Whitcroft <apw@canonical.com>,
	David Howells <dhowells@redhat.com>, tytso@mit.edu,
	Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@redhat.com>,
	linux-kernel@vger.kernel.org
References: <E1OMQ88-0002a1-Gb@closure.thunk.org>
 <AANLkTilqc0jpwnIwe3OIQvB9avaXXzrBK4Hz0huESygy@mail.gmail.com>
 <20100613194949.GC8055@thunk.org>
 <AANLkTilQLk7ofSJBm9KIa2g1KQ35GC1D1vOZlPrv1VRv@mail.gmail.com>
 <20100614184244.GA11480@elliptictech.com>
 <20100614214646.GF6666@thunk.org>
 <AANLkTikxOwYQYSzNjEqRduTQvoUandnAsZzm5Auzgnaz@mail.gmail.com>
 <18402.1276625268@redhat.com>
 <AANLkTilZElLEBJDjfpZVx72uDR-x_3t14Jkga5eHy3wf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTilZElLEBJDjfpZVx72uDR-x_3t14Jkga5eHy3wf@mail.gmail.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12:37 Wed 16 Jun     , Andy Whitcroft wrote:
> > Can you see what they're doing?
> >
> >        watch -n0 cat /sys/kernel/debug/slow_work/runqueue
> 
> Turned on the debugging and applied the patch from Ted, and when
> things are bad I see constant cycling of all four threads in the
> output showing similar to the below, note only one thread shows at a
> time:
> 
> Every 0.1s: cat /sys/kernel/debug/slow_work/runqueue    Wed Jun 16 12:34:52 2010
> 
> THR PID   ITEM ADDR        FL MARK  DESC
> === ===== ================ == ===== ==========
>    0   897 ffff88012bb07510 12  20ms DRM_CRTC_HELPER: i915@pci:0000:00:02.0

Indeed, this looks very similar to mine, except my DESC field is blank
for some reason.  The FL value is sometimes 12, sometimes 2.

When things are bad, all four of the kslowd threads are pegged at 16%
CPU usage.  On my T500, they _never_ calm down once they're pegged.
However, things seem to be working normally at boot.  It seems that
there is some initial trigger which pegs the threads, then the cursor
lag and other problems are just fallout after that.  The system is
essentially unusable after this point.

The threads sometimes get pegged immediately after booting the system,
sometimes it can last an hour or more before showing any problems.
Unfortunately, this is making bisection essentially impossible.

This seems to have been introduced somewhere between 2.6.35-rc1 and
-rc2.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
