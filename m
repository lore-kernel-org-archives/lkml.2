Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab0L3NJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 08:09:01 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:39432
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754225Ab0L3NJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 08:09:00 -0500
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzzz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LE8SIS-01-5OW-02
X-M-MSG: 
Date: Thu, 30 Dec 2010 14:08:53 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [GIT PULL] oprofile fixes for v2.6.37
Message-ID: <20101230130853.GA21073@erda.amd.com>
References: <20101229144702.GL4739@erda.amd.com>
 <20101229163743.GA27109@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20101229163743.GA27109@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.12.10 11:37:43, Ingo Molnar wrote:

> Hm, i'm not sure this fix is correct:
> 
>  static int op_amd_init(struct oprofile_operations *ops)
>  {
> +       /*
> +        * init_ibs() preforms implictly cpu-local operations, so pin this
> +        * thread to its current CPU
> +        */
> +       preempt_disable();
>         init_ibs();
> +       preempt_enable();
> 
> If init_ibs() is indeed CPU local, then it needs to be called on all CPUs.
> Does that happen and if not why not? AFAICS it's only called on one CPU.

It is correct to run init_ibs() only on one cpu.  It only checks the
ibs capabilities and sets up pci devices (if necessary). It runs only
on one cpu but operates with the local APIC and some MSRs, thus it is
better to disable preemption.

The cpu setup itself runs in op_amd_setup_ctrs() which is per cpu.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

