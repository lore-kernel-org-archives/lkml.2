Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab1DVWRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 18:17:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:50036 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab1DVWRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 18:17:05 -0400
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Stephane Eranian <eranian@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1303509293.4865.10.camel@laptop>
References: <1303407662-15564-1-git-send-email-acme@infradead.org>
	 <1303407662-15564-2-git-send-email-acme@infradead.org>
	 <20110422063429.GA16643@elte.hu>  <20110422080604.GA22611@elte.hu>
	 <1303508226.4865.8.camel@laptop>  <1303509293.4865.10.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Apr 2011 00:19:43 +0200
Message-ID: <1303510783.4865.14.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-22 at 23:54 +0200, Peter Zijlstra wrote:
> On Fri, 2011-04-22 at 23:37 +0200, Peter Zijlstra wrote:
> > The below needs filling out for !x86 (which I filled out with
> > unsupported events) and x86 needs the offcore bits fixed to auto select
> > between the two offcore events.
> 
> Urgh, so SNB has different MSR_OFFCORE_RESPONSE bits and needs another table.

/*
 * Sandy Bridge MSR_OFFCORE_RESPONSE bits;
 * See IA32 SDM Vol 3B 30.8.5
 */

#define SNB_DMND_DATA_RD	(1 << 0)
#define SNB_DMND_RFO		(1 << 1)
#define SNB_DMND_IFETCH		(1 << 2)
#define SNB_DMND_WB		(1 << 3)
#define SNB_PF_DATA_RD		(1 << 4)
#define SNB_PF_DATA_RFO		(1 << 5)
#define SNB_PF_IFETCH		(1 << 6)
#define SNB_PF_LLC_DATA_RD	(1 << 7)
#define SNB_PF_LLC_RFO		(1 << 8)
#define SNB_PF_LLC_IFETCH	(1 << 9)
#define SNB_BUS_LOCKS		(1 << 10)
#define SNB_STRM_ST		(1 << 11)
        			/* hole */
#define SNB_OFFCORE_OTHER	(1 << 15)
#define SNB_COMMON		(1 << 16)
#define SNB_NO_SUPP		(1 << 17)
#define SNB_LLC_HITM		(1 << 18)
#define SNB_LLC_HITE		(1 << 19)
#define SNB_LLC_HITS		(1 << 20)
#define SNB_LLC_HITF		(1 << 21)
				/* hole */
#define SNB_SNP_NONE		(1 << 31)
#define SNB_SNP_NOT_NEEDED	(1 << 32)
#define SNB_SNP_MISS		(1 << 33)
#define SNB_SNP_NO_FWD		(1 << 34)
#define SNB_SNP_FWD		(1 << 35)
#define SNB_HITM		(1 << 36)
#define SNB_NON_DRAM		(1 << 37)

#define SNB_DMND_READ		(SNB_DMND_DATA_RD)
#define SNB_DMND_WRITE		(SNB_DMND_RFO|SNB_DMND_WB|SNB_STRM_ST)
#define SNB_DMND_PREFETCH	(SNB_PF_DATA_RD|SNB_PF_DATA_RFO)

Is what I came up with, but I'm stumped on how to construct:

#define SNB_L3_HIT
#define SNB_L3_MISS

#define SNB_ALL_DRAM
#define SNB_REMOTE_DRAM

Anybody got clue?


