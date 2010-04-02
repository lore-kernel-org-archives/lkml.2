Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab0DBBxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 21:53:55 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:40818 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab0DBBxy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 21:53:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MTdLvv78/MYVUA4sDP42CpiyjUNV0/rJZ1caH6BWUkvL9TyhNhU7O/qkP7fzyYh2ol
         G5ZfL1JMhdksDuPV//M87Qtcs9v/8RFuiskkV68W5A4YIXCMBjFrU1kx6kr6uwbKNDnA
         MsSBvDwXVRCVymY8ZTDWg48AveqUXZAWvlA1M=
MIME-Version: 1.0
In-Reply-To: <1270156741.2192.14.camel@edumazet-laptop>
References: <o2vd585dc4f1004011212s65cc2beewed2f19321210a249@mail.gmail.com>
	 <1270156741.2192.14.camel@edumazet-laptop>
Date: Thu, 1 Apr 2010 20:53:52 -0500
Message-ID: <r2pd585dc4f1004011853q405eaadcq14b50a9e7a4dcf21@mail.gmail.com>
Subject: Re: Increased Latencies when upgrading kernel version
From: Taylor Lewick <taylor.lewick@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay.  I will get this info out to the list Monday.  Briefly, I'm
using identical hardware (server), identical NICs, same drivers,
connected to same switch, and using udpping, hackbench, and an
internall written app to test latency.  Without exception the
evolution has looked like the following.

2.6.16.60 latencies for system and network are fast.  Meaning
hackbench and udpping win, and win by quite a bit.

2.6.27.19 was awful.  2.6.32.1 and 2.6.331. were better for networking
(with some tweaks, i.e. disable netfilter, etc), and I was able to get
networking latencies to within 1-3 microseconds of 2.6.16.60
latencies, but the hackbench results are still pretty bad.

Again, I'll post numbers and more detailed hardware info on Monday
when I'm back at office...

On Thu, Apr 1, 2010 at 4:19 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le jeudi 01 avril 2010 à 14:12 -0500, Taylor Lewick a écrit :
>> For some time now we've been running an older kernel, 2.6.16.60.  When
>> we tried to upgrade, first going to 2.6.27.19 and then to 2.6.32.1 and
>> 2.6.33.1 we noticed that latencies increased.  At first we noticed it
>> by doing network tests via udpping, netperf, etc.  We made some
>> tweaks, and were able to get network latency to within 1 to 2
>> microseconds of where we were previously on 2.6.16.60.  Then we did
>> some more testing, and noticed that system latency also seems higher.
>>
>> We've done our tests on identical hardware servers, same NICs,
>> connected through same network gear.  Basically, we've tried to keep
>> everything identical except the kernel versions, and we are unable to
>> achieve the same performance for system latency on the newer kernels,
>> despite adjusting various kernel settings and recompiling.
>>
>> The latency differences are about 15 microseconds per transaction.
>>
>> At this point, I don't know what else to try.  I haven't played around
>> with the /proc/sys/kernel/sched_* paramaters under the newer kernels
>> yet.  Have tried changing pre-emption modes with little effect, in
>> fact, voluntary preemption seems to be peforming the best for us.
>>
>> At this time the realtime patch isn't really an option for us to
>> consider, at least not yet.
>>
>> Any suggestions?  Is this a known issue when upgrading to more recent
>> kernel versions?
>>
>
> Hi Taylor
>
> Well, this is bit difficult to generically answer to your generic
> question. 15 us more latency per transaction seems pretty bad.
>
> Some inputs would be nice, describing your workload and
> software/hardware architecture.
>
> lspci
> cat /proc/cpuinfo
> cat /proc/interrupts
> dmesg
> ethtool -S eth0
> ethtool -c eth0
>
>
>
>
