Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282Ab2IKPMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 11:12:07 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:13890
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752889Ab2IKPME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 11:12:04 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432I4015Izz1202h1d1ahzzz2dh668h839h944hd25hf0ah11b5h121eh1220h1288h12a5h12a9h12bdh1155h)
X-WSS-ID: 0MA6Y7V-02-HG5-02
X-M-MSG: 
Date: Tue, 11 Sep 2012 17:11:52 +0200
From: Robert Richter <robert.richter@amd.com>
To: David Ahern <dsahern@gmail.com>
CC: <acme@ghostprotocols.net>, <linux-kernel@vger.kernel.org>,
        <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 3/3] perf tool: give user better message if precise is
 not supported
Message-ID: <20120911151152.GW8285@erda.amd.com>
References: <1347295216-1202-1-git-send-email-dsahern@gmail.com>
 <1347295216-1202-4-git-send-email-dsahern@gmail.com>
 <20120911092026.GU8285@erda.amd.com>
 <504F3B18.90403@gmail.com>
 <20120911140148.GV8285@erda.amd.com>
 <504F4B97.3040701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <504F4B97.3040701@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.09.12 08:32:55, David Ahern wrote:
> My guess would be /usr/include/bits/errno.h:
> 
> /* Linux has no ENOTSUP error code.  */
> # define ENOTSUP EOPNOTSUPP

Ok, so ENOTSUP is actually the same as EOPNOTSUPP. Since the syscall
returns a EOPNOTSUPP, I prefer this when checking perf_event_open()
return codes. ENOTSUP is not used in the kernel. Was there a reason
for choosing ENOTSUP?

> > If you run this bare-metal on older machines which do not support pebs
> > or ibs, the syscall returns EOPNOTSUPP. You can trigger the same
> > behaviour on newer systems with:
> >
> >   # perf record -e cycles:ppp -c 2097120 -R -a sleep 1
> >
> >     Error: sys_perf_event_open() syscall returned with 95 (Operation not supported).  /bin/dmesg may provide additional information.
> >   ...
> >
> > It should work in this case too.
> 
> The commit message was a copy and paste from the failure of both :p in a 
> VM (PEBS is not supported in a VM). I also ran the bare metal case with 
> :pG which per the second patch in this series generates the not 
> supported message.

Since the error codes are the same, your code should work also on
bare-metal. Can you test on a host using :ppp? This should trigger the
same error message as in a vm.

Thanks,

-Robert


-- 
Advanced Micro Devices, Inc.
Operating System Research Center

