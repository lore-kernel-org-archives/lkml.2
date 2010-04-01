Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab0DAVTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 17:19:08 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:47633 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab0DAVTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 17:19:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wkmBGAR0QlbghHoww2qEWwfCj87pdokuEb3S/2aSSeVVV2Rpusamh1vFyMRbgC0JUn
         uu5BaGnsLdOJhK7WQTYOFYq5wy/WOVB12O0C15bbYicpoH1b/Dw7l/hxkI+mDLqoek4q
         8Agns5LjvU1KAWtWPXqXaQcVCmmyVa7+NF08w=
Subject: Re: Increased Latencies when upgrading kernel version
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Taylor Lewick <taylor.lewick@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <o2vd585dc4f1004011212s65cc2beewed2f19321210a249@mail.gmail.com>
References: <o2vd585dc4f1004011212s65cc2beewed2f19321210a249@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Apr 2010 23:19:01 +0200
Message-ID: <1270156741.2192.14.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 01 avril 2010 à 14:12 -0500, Taylor Lewick a écrit :
> For some time now we've been running an older kernel, 2.6.16.60.  When
> we tried to upgrade, first going to 2.6.27.19 and then to 2.6.32.1 and
> 2.6.33.1 we noticed that latencies increased.  At first we noticed it
> by doing network tests via udpping, netperf, etc.  We made some
> tweaks, and were able to get network latency to within 1 to 2
> microseconds of where we were previously on 2.6.16.60.  Then we did
> some more testing, and noticed that system latency also seems higher.
> 
> We've done our tests on identical hardware servers, same NICs,
> connected through same network gear.  Basically, we've tried to keep
> everything identical except the kernel versions, and we are unable to
> achieve the same performance for system latency on the newer kernels,
> despite adjusting various kernel settings and recompiling.
> 
> The latency differences are about 15 microseconds per transaction.
> 
> At this point, I don't know what else to try.  I haven't played around
> with the /proc/sys/kernel/sched_* paramaters under the newer kernels
> yet.  Have tried changing pre-emption modes with little effect, in
> fact, voluntary preemption seems to be peforming the best for us.
> 
> At this time the realtime patch isn't really an option for us to
> consider, at least not yet.
> 
> Any suggestions?  Is this a known issue when upgrading to more recent
> kernel versions?
> 

Hi Taylor

Well, this is bit difficult to generically answer to your generic
question. 15 us more latency per transaction seems pretty bad.

Some inputs would be nice, describing your workload and
software/hardware architecture.

lspci
cat /proc/cpuinfo
cat /proc/interrupts
dmesg
ethtool -S eth0
ethtool -c eth0



