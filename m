Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab1JATLy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 15:11:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55360 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab1JATLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 15:11:49 -0400
Subject: Re: big picture UDP/IP performance question re 2.6.18 -> 2.6.32
From: Eric Dumazet <eric.dumazet@gmail.com>
To: starlight@binnacle.cx
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <6.2.5.6.2.20111001141002.05af4b20@binnacle.cx>
References: <6.2.5.6.2.20111001141002.05af4b20@binnacle.cx>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 01 Oct 2011 21:11:43 +0200
Message-ID: <1317496303.3802.25.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 01 octobre 2011 à 14:16 -0400, starlight@binnacle.cx a écrit :
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
> 

2.6.32 has a perf tool, that can really help to spot in a few minutes
hot spots. That would definitely help to further diagnose what could be
the problem in your workload.

A single patch can have huge performance impact, sometime not noticed.

For example, in 2.6.36, AF_UNIX support for pid namespaces dropped
performance a lot [commit 7361c36c5224 (af_unix: Allow credentials to
work across user and pid namespaces)], because of a single atomic
operation, but done on each send() and receive() on a central location.



