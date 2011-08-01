Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab1HAFVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 01:21:40 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:56300
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752369Ab1HAFVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 01:21:34 -0400
X-SpamScore: -19
X-BigFish: VPS-19(zz936eK146fK1432N98dKzz1202hzz5eeeM8275bhz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LP8HJR-01-27O-02
X-M-MSG: 
Date: Mon, 1 Aug 2011 07:21:28 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] perf, x86: Implement AMD IBS
Message-ID: <20110801052128.GW4590@erda.amd.com>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
 <1311959236.5890.420.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1311959236.5890.420.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.07.11 13:07:16, Peter Zijlstra wrote:
> On Thu, 2011-07-28 at 15:46 +0200, Robert Richter wrote:
> > This patch set adds support for AMD IBS to perf. 
> 
> > The approach is still to collect raw sample data which should be the
> > most important use case for application developers. The data format is
> > the same as described in the IBS register specification.
> 
> That makes it hardware dependent right? I take it new hardware with IBS
> extensions adds output MSRs.

IBS is supposed to be architectural spec'ed, meaning there are no
family checks. IBS features are detected using cpuid.

So the version of the raw sampling data format could be specified with
the u32 capability variable. I could put the caps value to the raw
sample data too right after the size field. An additional advantage
would be that 64 bit values are memory alligned then.

The Branch Target Address register that has been added to newer cpus
could simply be extended to the raw data sample, the data would still
be backward compatible. Userland can detect it existence from the
sample size or (better) from the ibs caps.

> Anyway, I'll try and go over it again next week after reading the IBS
> hardware spec (again.. that stuff just won't stick to memory).
> 
> I've got the BKDG for Fam10, is there anything more I should read?

Though it is treated architectural, it isn't in the AMD64 Architecture
Programmer's Manual (APM). The 10h BKDG is a good source, but extended
IBS features are described in the family 12h bkdg (same as for 15h)
and the capabilities are in the cpuid spec:

 http://support.amd.com/us/Processor_TechDocs/41131.pdf
 http://support.amd.com/us/Processor_TechDocs/25481.pdf

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

