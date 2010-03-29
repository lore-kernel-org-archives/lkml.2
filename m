Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab0C2Q5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:57:39 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:1090 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab0C2Q5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:57:37 -0400
Message-ID: <4BB0DBFD.30904@hp.com>
Date: Mon, 29 Mar 2010 09:57:33 -0700
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
References: <4BB09021.6020202@petalogix.com> <4BB0D9A1.3090107@hp.com>
In-Reply-To: <4BB0D9A1.3090107@hp.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rick Jones wrote:
> I don't know how to set fixed socket buffer sizes in iperf, if you were 
> running netperf though I would suggest fixing the socket buffer sizes 
> with the test-specific -s (affects local) and -S (affects remote) options:
> 
> netperf -t TCP_STREAM -H <remote> -l 30 -- -s 32K -S 32K -m 32K
> 
> to test the hypothesis that the autotuning of the socket buffers/window 
> size is allowing the windows to grow in the larger memory cases beyond 
> what the TLB in your processor is comfortable with.

BTW, by default, netperf will allocate a "ring" of send buffers - the number 
allocated will be one more than the socket buffer size divided by the send size 
- so in the example above, there will be two 32KB buffers allocated in netperf's 
send ring.  A similar calculation may happen on the receive side.

That can be controlled via the global (before the "--") -W option.

     -W send,recv      Set the number of send,recv buffers

So, you might make the netperf command:

netperf -t TCP_STREAM -H <remote> -l 30 -W 1,1 -- -s 32K -S 32K -m 32K

happy benchmarking,

rick jones
