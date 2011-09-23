Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab1IWKNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 06:13:18 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:50685 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab1IWKNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 06:13:10 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zz98dKzz1202hzzz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LRZ0DR-02-2MM-02
X-M-MSG: 
Date: Fri, 23 Sep 2011 12:13:05 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "acme@redhat.com" <acme@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v5)
Message-ID: <20110923101305.GO6063@erda.amd.com>
References: <20110922123128.GA9761@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110922123128.GA9761@quad>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.09.11 08:31:28, Stephane Eranian wrote:
> We define the following useful new extensions:
>  - HEADER_HOSTNAME: the hostname
>  - HEADER_OSRELEASE: the kernel release number
>  - HEADER_ARCH: the hw architecture
>  - HEADER_CPUDESC: generic CPU description
>  - HEADER_NRCPUS: number of online/avail cpus
>  - HEADER_CMDLINE: perf command line
>  - HEADER_VERSION: perf version
>  - HEADER_TOPOLOGY: cpu topology
>  - HEADER_EVENT_DESC: full event description (attrs)
>  - HEADER_CPUID: easy-to-parse low level CPU identication

Stephane,

could we also put in the dynamical pmu mapping? This is important
esp. for decoding samples of dynamically registered pmus (ibs_op,
ibs_fetch, uncore, etc.). We need the type/name mapping information in
the header and the type encoding in the sample, e.g on a system with:

 # cat /sys/devices/ibs_fetch/type
 6
 # cat /sys/devices/ibs_op/type
 7

the header could contain something like:

 HEADER_DYN_PMUS: ibs_fetch=6, ibs_op=7

Then we can encode the (dynamically generated) type value in the
sample and a parser may know its origin and format. This way we could
write costumized data sample parser which may detect the sampling
format from perf.data.

E.g. perf report could be used to encode IBS data samples without any
architectural or pmu specific command line.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

