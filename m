Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab1KAJup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 05:50:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab1KAJuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 05:50:44 -0400
Message-ID: <4EAFC15C.7010601@redhat.com>
Date: Tue, 01 Nov 2011 17:52:28 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: kexec@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, vgoyal@redhat.com, horms@verge.net.au,
        luyu@redhat.com
Subject: Re: [PATCH retry] intel-iommu:make identity_map default for crash
 dump
References: <20111101091939.GA8985@darkstar.nay.redhat.com> <1320140052.2089.5.camel@shinybook.infradead.org>
In-Reply-To: <1320140052.2089.5.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2011 05:34 PM, David Woodhouse wrote:

> On Tue, 2011-11-01 at 17:19 +0800, Dave Young wrote:
>> kdump kernel sometimes will get DMAR faults which
>> is caused by random in-flight dma from 1st kernel
>>
>> Here make the identity_mapping as default for this case
> 
> So you want to *allow* the random in-flight DMA? And with an identity
> mapping it's really going to random addresses, since it'll be
> untranslated and won't even go to the physical addresses which it was
> originally intended for?
> 
> This seems entirely broken to me.
> 
> If there is "random in-flight dma" from the first kernel, the correct
> thing to do is *block* it. Which is what we do.
> 


This patch works for me for several cases. For kdump It can be seen a
workaround. But yes blocking the 1st kernel dma is ideal.

Glad to hear that you are working on this.

-- 
Thanks
Dave
