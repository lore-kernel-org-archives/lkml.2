Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab2EOLgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 07:36:05 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36901 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433Ab2EOLgC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 07:36:02 -0400
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <pantelis.antoniou@gmail.com>
In-Reply-To: <1337077714.27694.21.camel@twins>
Date: Tue, 15 May 2012 14:35:53 +0300
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        mou Chen <hi3766691@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, torvalds@linux-foundation.org
Content-Transfer-Encoding: 8BIT
Message-Id: <9093E8BA-80E4-4113-B036-0259E5FB44F1@gmail.com>
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com> <CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com> <CANQmPXj_81NBBrTYCkhUO1k1i4WVu0iHwY1_10wDVOFWCSkvsw@mail.gmail.com> <CAKfTPtBhPpQyr1qugbMzq2nENh+zBT+zx_nWQpQ9NPbF=+ppcQ@mail.gmail.com> <833A8DB8-1AB4-45E4-8D44-14A0D782807D@gmail.com> <1337077714.27694.21.camel@twins>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 15, 2012, at 1:28 PM, Peter Zijlstra wrote:

> On Tue, 2012-05-15 at 12:17 +0300, Pantelis Antoniou wrote:
>> IMO this whole idea about 'server' or 'desktop' schedulers is bunk.
> 
> Yeah, its complete shite. Everybody cares about throughput, latency and
> power. The exact balance might differ between workloads but those cannot
> be split between desktop/server at all. Furthermore, nobody wants one at
> all costs to the others.

Expanding on this a little more, the balancing between the factors might
vary according to the workload you run at the time and not on a pre-set
scenario at the time.

For example take a server configuration, one would expect it to be geared
towards throughput with no regard to power or latency. This is not the
case today. Power saving can be considerable, and low latency might be
very desirable if you run on it stuff like a VoIP based soft PBX.

Same with a desktop, running ooffice and a browser most of the time, but
you would expect to run a game or an audio editing/performing application.

The smart-phone case is like juggling coals; you need to have the minimum
amount of power draw, but you better offer minimum latency and high
throughtput when pissed-off-avians is on. 

Now the question is how to fit this in a scheduler policy.

We have the 3 ones that Peter mentioned;

Throughput
Latency
Power

I can think of two more; thermal management, and memory I/O.

What other can we come up with? And what are the units that we are going
to measure them with?

For example:

Throughput: MIPS(?), bogo-mips(?), some kind of performance counter?

Latency: usecs(?)

Power: Now that's a tricky one, we can't measure power directly, it's a
function of the cpu load we run in a period of time, along with any
history of the cstates & pstates of that period. How can we collect
information about that? Also we to take into account peripheral device
power to that; GPUs are particularly power hungry. 

Thermal management: How to distribute load to the processors in such
a way that the temperature of the die doesn't increase too much that
we have to either go to a lower OPP or shut down the core all-together.
This is in direct conflict with throughput since we'd have better performance 
if we could keep the same warmed-up cpu going.

Memory I/O: Some workloads are memory bandwidth hungry but do not need
much CPU power. In the case of asymmetric cores it would make sense to move
the memory bandwidth hog to a lower performance CPU without any impact. 
Probably need to use some kind of performance counter for that; not going
to be very generic.

Any more ideas?

Regards

-- Pantelis
  