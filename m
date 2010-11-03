Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab0KCHT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 03:19:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:46440 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186Ab0KCHT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 03:19:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,288,1286175600"; 
   d="scan'208";a="623035171"
Subject: Re: [RFC 4/4]x86: avoid tlbstate lock if no enough cpus
From: Shaohua Li <shaohua.li@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, "hpa@zytor.com" <hpa@zytor.com>
In-Reply-To: <1288768330.2467.660.camel@edumazet-laptop>
References: <1288766668.23014.117.camel@sli10-conroe>
	 <1288767580.2467.636.camel@edumazet-laptop>
	 <1288767995.23014.120.camel@sli10-conroe>
	 <1288768330.2467.660.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 15:19:55 +0800
Message-ID: <1288768795.23014.123.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-03 at 15:12 +0800, Eric Dumazet wrote:
> Le mercredi 03 novembre 2010 à 15:06 +0800, Shaohua Li a écrit :
> > just don't want to include the non-present cpus here. I wonder why we
> > haven't a variable to record online cpu number.
> 
> What prevents a 256 cpus machine, to have 8 online cpus that all use the
> same TLB vector ?
> 
> (Max 32 vectors, so 8 cpus share each vector, settled at boot time)
> 
> Forget about 'online', and think 'possible' ;)
Hmm, the spread vectors to node already merged, how could the 8 cpus
share a vector?

