Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab2H0TRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 15:17:37 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:7670
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753811Ab2H0TRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 15:17:36 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1202hzzz2dh668h839h944hd25hd2bhf0ah107ah1155h)
X-WSS-ID: 0M9FHL7-01-59S-02
X-M-MSG: 
Date: Mon, 27 Aug 2012 14:17:30 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 3/5] x86: Only direct map addresses that are marked as
 E820_RAM
Message-ID: <20120827191729.GB23135@jshin-Toonie>
References: <1345852516-3125-1-git-send-email-jacob.shin@amd.com>
 <1345852516-3125-4-git-send-email-jacob.shin@amd.com>
 <50381C9D.5070007@zytor.com>
 <20120825004859.GB10812@jshin-Toonie>
 <5038269E.80707@zytor.com>
 <20120825042020.GC26127@jshin-Toonie>
 <503852BE.1010908@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <503852BE.1010908@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 09:21:18PM -0700, H. Peter Anvin wrote:
> On 08/24/2012 09:20 PM, Jacob Shin wrote:
> >>
> >>What is the benefit?
> >
> >So that in the case where we have E820_RAM right above 1MB, we don't
> >call init_memory_mapping twice, first on 0 ~ 1MB and then 1MB ~ something
> >
> >we only call it once. 0 ~ something.
> >
> 
> So what is the benefit?

if there is E820_RAM right above ISA region, then you get to initialize
0 ~ max_low_pfn in one big chunk, which results in some memory configurations
for more 2M or 1G page tables which means less space used for page tables.

im also worried about the case where that first call to init_memory_mapping
for 0 ~ 1MB, results in max_pfn_mapped = 1MB, and the next call to
init_memory_mapping is some large enough area, where we don't have enough
space under 1MB for all the page tables needed (maybe only 4K page tables
are supported or something).

-Jacob

> 
> 	-hpa
> 
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
> 
> 

