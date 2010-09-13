Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab0IMBTG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 21:19:06 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:39709 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab0IMBTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 21:19:04 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L8NVK7-02-C20-02
X-M-MSG: 
Date: Mon, 13 Sep 2010 03:16:55 +0200
From: Robert Richter <robert.richter@amd.com>
To: Huang Ying <ying.huang@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 4/6] x86, NMI, Rewrite NMI handler
Message-ID: <20100913011655.GI21909@erda.amd.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
 <1284087065-32722-4-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1284087065-32722-4-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.09.10 22:51:03, Huang Ying wrote:
> DIE_NMI_IPI is used to process CPU specific NMI sources, such as perf
> event, oprofile, crash IPI, etc. While DIE_NMI is used to process
> non-CPU-specific NMI sources, such as APEI (ACPI Platform Error
> Interface) GHES (Generic Hardware Error Source), etc.
> 
> DIE_NMI_IPI must be processed before DIE_NMI. For example, perf event
> trigger a NMI on CPU 1, at the same time, APEI GHES trigger another
> NMI on CPU 0. If DIE_NMI is processed before DIE_NMI_IPI, it is
> possible that APEI GHES is processed on CPU 1, while unknown NMI is
> gotten on CPU 0.

Ingo, Peter,

couldn't this be the reason for the regression we are observing with
unhandled nmis?

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

