Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab1A0MFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 07:05:33 -0500
Received: from ch1outboundpool.messaging.microsoft.com ([157.55.116.160]:32750
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754368Ab1A0MFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 07:05:31 -0500
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Jan 2011 07:05:31 EST
X-SpamScore: -11
X-BigFish: VPS-11(zz1432N98dNzz1202hzz8275bhz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LFOJJV-02-3ME-02
X-M-MSG: 
Date: Thu, 27 Jan 2011 12:50:17 +0100
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 4/4] x86, amd: Support L3 Cache Partitioning on AMD
 family 0x15 CPUs
Message-ID: <20110127115017.GH877@escobedo.osrc.amd.com>
References: <20110126105637.GA27809@elte.hu>
 <1296061716-185599-1-git-send-email-hans.rosenfeld@amd.com>
 <20110126205608.GA14361@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110126205608.GA14361@elte.hu>
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach b.
 Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach,
 Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr.
 43632
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 03:56:08PM -0500, Ingo Molnar wrote:
> * Hans Rosenfeld <hans.rosenfeld@amd.com> wrote:
> > +#ifdef CONFIG_SMP
> > +int amd_get_subcaches(int cpu)
> 
> Well, sprinkling it with CONFIG_SMP is pretty ugly. Also, there's no fundamental 
> reason why this shouldnt work with UP. Yes, it makes most sense on SMP but such code 
> should be SMP-invariant.

True, it is pretty ugly. And while the feature is pretty useless for UP,
it would still work for compute_unit_id 0 in that case.

The problem is that cpuinfo_x86.compute_unit_id etc. don't exist unless
CONFIG_SMP is enabled. I don't think there is any reason why this should
be that way, but changing this just for this particular L3 feature seems
too intrusive. Do you really want me to do that?


Hans


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

