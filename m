Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965366Ab1JGDde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 23:33:34 -0400
Received: from mx.binnacle.cx ([74.95.187.105]:58315 "EHLO mx.binnacle.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935808Ab1JGDdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 23:33:32 -0400
Message-Id: <6.2.5.6.2.20111006231958.039bb570@binnacle.cx>
X-Mailer: QUALCOMM Windows Eudora Version 6.2.5.6
Date: Thu, 06 Oct 2011 23:27:35 -0400
To: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Lameter <cl@gentwo.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Willy Tarreau <w@1wt.eu>,
        Ingo Molnar <mingo@elte.hu>,
        Stephen Hemminger <stephen.hemminger@vyatta.com>,
        Benjamin LaHaise <bcrl@kvack.org>, Joe Perches <joe@perches.com>,
        Chetan Loke <Chetan.Loke@netscout.com>,
        Con Kolivas <conman@kolivas.org>,
        Serge Belyshev <belyshev@depni.sinp.msu.ru>
From: starlight@binnacle.cx
Subject: Re: big picture UDP/IP performance question re 2.6.18 
  -> 2.6.32
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After writing the last post, the large
difference in IRQ rate between the older
and newer kernels caught my eye.

I wonder if the hugely lower rate in the older
kernels reflects a more agile shifting
into and out of NAPI mode by the network
bottom-half.

In this test the sending system
pulses data out on millisecond boundaries
due to the behavior of nsleep(), which
is used to establish the playback pace.

If the older kernels are switching to NAPI
for much of surge and the switching out
once the pulse falls off, it might
conceivably result in much better latency
and overall performance.

All tests were run with Intel 82571 
network interfaces and the 'e1000e'
device driver.  Some used the driver
packaged with the kernel, some used
Intel driver compiled from the source
found on sourceforge.net.  Never could
detected any difference between the two.

Since data in the production environment
also tends to arrive in bursts, I don't find
the pulsing playback behavior a detriment.

