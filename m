Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab0C2Qrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:47:35 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:31342 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab0C2Qrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:47:33 -0400
Message-ID: <4BB0D9A1.3090107@hp.com>
Date: Mon, 29 Mar 2010 09:47:29 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: michal.simek@petalogix.com
CC: LKML <linux-kernel@vger.kernel.org>,
       John Williams <john.williams@petalogix.com>, netdev@vger.kernel.org,
       Grant Likely <grant.likely@secretlab.ca>,
       John Linn <John.Linn@xilinx.com>,
       "Steven J. Magnani" <steve@digidescorp.com>,
       Arnd Bergmann <arnd@arndb.de>, akpm@linux-foundation.org
Subject: Re: Network performance - iperf
References: <4BB09021.6020202@petalogix.com>
In-Reply-To: <4BB09021.6020202@petalogix.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know how to set fixed socket buffer sizes in iperf, if you were running 
netperf though I would suggest fixing the socket buffer sizes with the 
test-specific -s (affects local) and -S (affects remote) options:

netperf -t TCP_STREAM -H <remote> -l 30 -- -s 32K -S 32K -m 32K

to test the hypothesis that the autotuning of the socket buffers/window size is 
allowing the windows to grow in the larger memory cases beyond what the TLB in 
your processor is comfortable with.

Particularly if you didn't see much degredation as RAM is increased on something 
like:

netperf -t TCP_RR -H <remote> -l 30 -- -r 1

which is a simple request/response test that will never try to have more than 
one packet in flight at a time, regardless of how large the window gets.

happy benchmarking,

rick jones
http://www.netperf.org/
