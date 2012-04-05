Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab2DERTE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 13:19:04 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:54798
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755204Ab2DERSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 13:18:53 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zzbb2dI9371I1432N98dKzz1202hzzz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M20O38-02-721-02
X-M-MSG: 
Date: Thu, 5 Apr 2012 19:18:45 +0200
From: Robert Richter <robert.richter@amd.com>
To: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf tools: Use sw counter only if hw pmu is not
 detected
Message-ID: <20120405171844.GO16322@erda.amd.com>
References: <1333643188-26895-1-git-send-email-robert.richter@amd.com>
 <1333643188-26895-5-git-send-email-robert.richter@amd.com>
 <4F7DCF58.8020601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F7DCF58.8020601@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.04.12 10:59:04, David Ahern wrote:
> On 4/5/12 10:26 AM, Robert Richter wrote:
> > Use cpu-clock-tick sw counter for cpu-cycles only if there is no hw
> > pmu available. This is the case if the syscall reports ENOENT. In
> > other cases (e.g. invalid attributes) we don't want the sw counter to
> > be used.
> 
> Isn't the invalid attributes case handled by the
> '} else if (err == EINVAL) {'
> case before this switch is done?

Yes, but it does not jump out the code path. It is only doing some
diagnostics and retries the syscall with some modified attributes or
so.

I had have the case what a syscall failed due to invalid attributes
and then the sw counter was setup. I got odd results and I needed some
time debugging this to realize what was going on.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

