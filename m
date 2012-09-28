Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab2I1Oca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:32:30 -0400
Received: from mx2.parallels.com ([64.131.90.16]:37258 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757673Ab2I1Oc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:32:29 -0400
Message-ID: <5065B42F.5010007@parallels.com>
Date: Fri, 28 Sep 2012 18:29:03 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] make GFP_NOTRACK flag unconditional
References: <1348826194-21781-1-git-send-email-glommer@parallels.com> <0000013a0d475174-343e3b17-6755-42c1-9dae-a9287ad7d403-000000@email.amazonses.com>
In-Reply-To: <0000013a0d475174-343e3b17-6755-42c1-9dae-a9287ad7d403-000000@email.amazonses.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 06:28 PM, Christoph Lameter wrote:
> On Fri, 28 Sep 2012, Glauber Costa wrote:
> 
>> There was a general sentiment in a recent discussion (See
>> https://lkml.org/lkml/2012/9/18/258) that the __GFP flags should be
>> defined unconditionally. Currently, the only offender is GFP_NOTRACK,
>> which is conditional to KMEMCHECK.
>>
>> This simple patch makes it unconditional.
> 
> __GFP_NOTRACK is only used in context where CONFIG_KMEMCHECK is defined?
> 
> If that is not the case then you need to define GFP_NOTRACK and substitute
> it where necessary.
> 

The flag is passed around extensively, but I was imagining the whole
point of that is that having the flag itself is harmless, and will be
ignored by the page allocator ?


