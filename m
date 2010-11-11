Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab0KKTpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:45:13 -0500
Received: from mga03.intel.com ([143.182.124.21]:39904 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553Ab0KKTpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:45:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,184,1288594800"; 
   d="scan'208";a="347625724"
Message-ID: <4CDC47C3.3040102@linux.intel.com>
Date: Thu, 11 Nov 2010 20:45:07 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@elte.hu, acme@redhat.com, eranian@google.com
Subject: Re: [PATCH 1/3] perf-events: Add support for supplementary event
 registers
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org>	 <1289502554.2084.153.camel@laptop> <20101111192551.GI18718@basil.fritz.box> <1289504197.2084.172.camel@laptop>
In-Reply-To: <1289504197.2084.172.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2010 8:36 PM, Peter Zijlstra wrote:
>
> Can we make it so, that is, move that int inside the intel_percore
> struct?
>

It's needed per cpu. Basically the flag says "bother to look into the 
percore structure"
This way most of this is kept out of the fast paths. But one CPU in a core
may need it and the other not.

In principle it could be merged into some other cpuc flag word if you 
have any suggestions.

>
> Hrm,.. but we only need to do this on nhm/wsm init, we already have code
> detecting the cpu model. And I'm quite sure you know where to poke to
> see if HT is enabled.

Ok I guess I can do a dynamic per cpu allocation for this case.

-Andi
