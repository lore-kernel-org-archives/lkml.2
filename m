Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757Ab2IJNH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 09:07:27 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:42925
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751229Ab2IJNHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 09:07:25 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1202h1d1ahzzz2dh668h839h944hd25hf0ah11b5h121eh1220h1288h12a5h12a9h1155h)
X-WSS-ID: 0MA4XS2-02-8B5-02
X-M-MSG: 
Date: Mon, 10 Sep 2012 15:07:00 +0200
From: Robert Richter <robert.richter@amd.com>
To: David Ahern <dsahern@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf, ibs: Check syscall attribute flags
Message-ID: <20120910130700.GS8285@erda.amd.com>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
 <1342826756-64663-9-git-send-email-dsahern@gmail.com>
 <20120906190238.GA29278@erda.amd.com>
 <5048F6BF.70106@gmail.com>
 <20120906195645.GD8285@erda.amd.com>
 <20120907164114.GJ8285@erda.amd.com>
 <504A25DB.2030100@gmail.com>
 <20120907170700.GK8285@erda.amd.com>
 <504A2ADC.4050703@gmail.com>
 <504A2CD3.9060204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <504A2CD3.9060204@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.09.12 11:20:19, David Ahern wrote:
> I see now... intel returns ENOTSUP if exclude_guest is not set, amd 
> returns EINVAL if it is set.
> 
> For the AMD case the fallback_missing_features code kicks in for 
> perf-top and perf-record; I just need to fix up the pr_debug for that case.

It is EOPNOTSUP. I preferred returning EOPNOTSUP too. But then I saw
that fallback code is implemented to work mostly with EINVAL. It seems
to be the default answer to a syscall. ;)

There are several pieces of code in perf that implement fallback code,
it's hard to find it all and this already caused some bugs in the
past. I was looking at this to unify it, but it was too much effort.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

