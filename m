Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab1FPNUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 09:20:35 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:34473 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750944Ab1FPNUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 09:20:34 -0400
X-IronPort-AV: E=Sophos;i="4.65,375,1304287200"; 
   d="scan'208";a="111271083"
Date: Thu, 16 Jun 2011 15:20:32 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: "Cache" sched domains
Message-ID: <20110616132032.GO5583@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
	linux-kernel@vger.kernel.org,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venki@google.com>,
	Srivatsa Vaddagiri <vatsa@in.ibm.com>, Paul Turner <pjt@google.com>,
	Mike Galbraith <efault@gmx.de>,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>
References: <20110616121147.GA4644@const.bordeaux.inria.fr> <1308227242.13240.56.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1308227242.13240.56.camel@twins>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Peter Zijlstra, le Thu 16 Jun 2011 14:27:22 +0200, a écrit :
> On Thu, 2011-06-16 at 14:11 +0200, Samuel Thibault wrote:
> > ┌──────────────────────────────────────────────────────────────────┐
> > │Socket P#1                                                        │
> > │┌────────────────────────────────────────────────────────────────┐│
> > ││L3 (16MB)                                                       ││
> > │└────────────────────────────────────────────────────────────────┘│
> > │┌────────────────────┐┌────────────────────┐┌────────────────────┐│
> > ││L2 (3072KB)         ││L2 (3072KB)         ││L2 (3072KB)         ││
> > │└────────────────────┘└────────────────────┘└────────────────────┘│
> > │┌─────────┐┌─────────┐┌─────────┐┌─────────┐┌─────────┐┌─────────┐│
> > ││L1 (32KB)││L1 (32KB)││L1 (32KB)││L1 (32KB)││L1 (32KB)││L1 (32KB)││
> > │└─────────┘└─────────┘└─────────┘└─────────┘└─────────┘└─────────┘│
> > │┌─────────┐┌─────────┐┌─────────┐┌─────────┐┌─────────┐┌─────────┐│
> > ││Core P#0 ││Core P#1 ││Core P#2 ││Core P#3 ││Core P#4 ││Core P#5 ││
> > ││┌───────┐││┌───────┐││┌───────┐││┌───────┐││┌───────┐││┌───────┐││
> > │││PU P#0 ││││PU P#4 ││││PU P#8 ││││PU P#12││││PU P#16││││PU P#20│││
> > ││└───────┘││└───────┘││└───────┘││└───────┘││└───────┘││└───────┘││
> > │└─────────┘└─────────┘└─────────┘└─────────┘└─────────┘└─────────┘│
> > └──────────────────────────────────────────────────────────────────┘
> 
> Pretty, bonus points for effort there.

Well, that's all hwloc's credit :)

> So the current goal is to change sched_domain_topology to not be such a
> silly hard coded list of domains, but build that thing dynamically based
> on the system topology and set all the SD_flags correctly.

Ok, great!

> If that is something you're willing to work on, that'd be totally
> awesome.

I'm afraid I do not have time to spend on this.

Samuel
