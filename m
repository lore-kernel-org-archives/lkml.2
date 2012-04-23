Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab2DWIlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 04:41:39 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:45052 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754199Ab2DWIlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 04:41:37 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zz936eK1432N98dKzz1202hzz8275bh5eeeKz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2XC57-01-4GO-02
X-M-MSG: 
Date: Mon, 23 Apr 2012 10:41:28 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/12] perf/x86-ibs: Precise event sampling with IBS for
 AMD CPUs
Message-ID: <20120423084128.GR9747@erda.amd.com>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
 <1333390758-10893-7-git-send-email-robert.richter@amd.com>
 <1334398930.2528.50.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1334398930.2528.50.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.04.12 12:22:10, Peter Zijlstra wrote:
> On Mon, 2012-04-02 at 20:19 +0200, Robert Richter wrote:
> > + * IbsOpCntCtl (bit 19) of IBS Execution Control Register (IbsOpCtl,
> > + * MSRC001_1033) is used to select either cycle or micro-ops counting
> > + * mode. 
> 
> Ah is that what it does.. the BKDG doesn't appear to say this.

"19 IbsOpCntCtl: periodic op counter count control. Revision B:
    Reserved. Revision C: Read-write. Reset 0b. 1=Count dispatched ops
    0=Count clock cycles."

It's here:

 MSRC001_1033 IBS Execution Control Register (IbsOpCtl)
 http://support.amd.com/us/Processor_TechDocs/31116.pdf

Ok, it might not be quite clear that "dispatched ops" is related to
EventSelect 0C1h Retired uops, but there is an exact mapping.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

