Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab1CPPqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 11:46:10 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.181]:40300
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753392Ab1CPPqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 11:46:02 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzzz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LI5QGH-02-QNN-02
X-M-MSG: 
Date: Wed, 16 Mar 2011 16:45:53 +0100
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <ak@linux.intel.com>
CC: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>
Subject: Re: [PATCH] oprofile: Allow setting EDGE/INV/CMASK for Intel
 counter events
Message-ID: <20110316154553.GQ31407@erda.amd.com>
References: <1299870748-13319-1-git-send-email-andi@firstfloor.org>
 <20110316150450.GO31407@erda.amd.com>
 <20110316152757.GA12845@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110316152757.GA12845@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.03.11 11:27:57, Andi Kleen wrote:
> > I would like to write the actual value back so that userland may read
> > it:
> > 
> > 	counter_config->extra &= (ARCH_PERFMON_EVENTSEL_INV|
> >                          ARCH_PERFMON_EVENTSEL_EDGE|
> >                          ARCH_PERFMON_EVENTSEL_CMASK);
> > 	val |= counter_config->extra;
> > 
> > The value will not be updated emmediately but at least after profiling
> > was started.
> 
> Okay.
> 
> > 
> > As an alternative, maybe we better put this extra bits in the
> > unit_mask, e.g. in bits [31:16] of the unit mask for bits [31:16] of
> > PerfEvtSel? Then, we simply could use the current userland to set it
> > up.
> 
> We can't anyways, it doesn't support it.

Shouldn't something like the follwing work (assuming the umask table
is modified)?

 opcontrol --event SOME_EVENT:100000:0x00800000 ...

(setting the INV flag)

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

