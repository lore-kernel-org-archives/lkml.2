Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab1JASlH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 14:41:07 -0400
Received: from 1wt.eu ([62.212.114.60]:33330 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab1JASlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 14:41:00 -0400
Date: Sat, 1 Oct 2011 20:40:49 +0200
From: Willy Tarreau <w@1wt.eu>
To: starlight@binnacle.cx
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: big picture UDP/IP performance question re 2.6.18 -> 2.6.32
Message-ID: <20111001184049.GE18690@1wt.eu>
References: <6.2.5.6.2.20111001141002.05af4b20@binnacle.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6.2.5.6.2.20111001141002.05af4b20@binnacle.cx>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 02:16:05PM -0400, starlight@binnacle.cx wrote:
> At 08:44 AM 10/1/2011 +0200, Eric Dumazet wrote:
> >In my experience, I have the exact opposite :
> >performance greatly improved in recent
> >kernels. Unless you compile your kernel to include
> >new features that might reduce performance
> >(namespaces, cgroup, ...)
> 
> RH has both of the above turned on in the
> 2.6.32-71.29.1.el6.x86_64 kernel tested.
> 
> If these are big negatives to network
> performance, could you list what should
> specifically turned off to maximize
> results?  Also a recommendation for
> the best recent kernel for another
> benchmark would be helpful.
> 
> Probably can't convince anyone to deploy a
> kernel without commercial support, but if
> an alternate compile fixes performance it
> might be possible to convince RH to support
> the alternative build.

Just a suggestion, instead of measuring CPU usage at a
given load, could you check what maximal load you can
achieve ? It is very possible that CPU usage report is
not accurate. We observed this in a number of situations,
especially in high packet rate environments where the
usage is a sum of many micro-measurements.

Also, I did not notice any indication on the load level
you were reaching (packets per second and bandwidth).
Have you compared the interrupt rate ? It is possible
that they differ between the two kernels, for instance
because the NIC auto-adapts instead of being throttled
to a given rate. This can have a significant impact on
measurements and performance.

Regards,
Willy

