Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab0KKSmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 13:42:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:18987 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977Ab0KKSmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 13:42:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,184,1288594800"; 
   d="scan'208";a="625870684"
Message-ID: <4CDC38FB.20303@linux.intel.com>
Date: Thu, 11 Nov 2010 19:42:03 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        acme@redhat.com
Subject: Re: [PATCH 1/3] perf-events: Add support for supplementary event
 registers
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org> <AANLkTi=3xQd-anvwXryXASr1+Th1HSjTn8j-ZcRZko3b@mail.gmail.com>
In-Reply-To: <AANLkTi=3xQd-anvwXryXASr1+Th1HSjTn8j-ZcRZko3b@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2010 7:06 PM, Stephane Eranian wrote:

Thanks for the review.

> One thing I noticed in your patch is that you don't special
> case the configuration where HT is off. In that case, the
> sharing problem goes away. I think you could override
> either way during init.

The allocator should handle that transparently. With HT off the resource is
always free. Or do you see any concrete problems with the current code path?

> Some more tidbits:
> - OFFCORE_RESPONSE_0 is 0x01b7
> - OFFCORE_RESPONSE_1 is 0x01bb
>
> The umask is not zero but 1. Dont' know if you get
> something meaningful is you pass a umask of zero.

Hmm I seem to get events that look meaningful with 0. But you're right 1
is better. I used that in manual tests, but it wasn't in the cache number
mappings. I'll fix that for the next version.

-Andi

