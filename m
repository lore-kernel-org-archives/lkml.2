Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab1HEXxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 19:53:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57035 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006Ab1HEXxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 19:53:48 -0400
Message-ID: <4E3C827D.9040303@zytor.com>
Date: Fri, 05 Aug 2011 16:53:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [x86] Fix prefetch instruction
References: <alpine.DEB.2.00.1108051116520.28580@router.home> <4E3C4EF1.3040709@zytor.com> <alpine.DEB.2.00.1108051608110.4821@router.home> <4E3C5F03.8090100@linux.intel.com> <alpine.DEB.2.00.1108051831090.13276@router.home>
In-Reply-To: <alpine.DEB.2.00.1108051831090.13276@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2011 04:32 PM, Christoph Lameter wrote:
>>
>> Right.  However, Linus has brought up the hypothesis that prefetch might
>> actually be a net loss on x86, because current x86 processors are
>> generally doing a good job with prefetching in hardware.  Directed
>> prefetches can thus be a net minus.
> 
> This kinid of prefetch is a minus because the cache is evicted early. It
> was prefetched with a special hint so its likely very important. That does
> not seem to be very consistent and may cause regressions. Changing it to a
> full prefetch would make the important cacheline stay longer in the cache.
> 

The argument applies not just to NTA prefetches, though.  There is a
pipeline cost to performing the software prefetch action, it can cause
evictions if the data is not used, and it can increase TLB pressure.

As such, it would be very interesting to know if prefetch0 or nothing is
the better; agree we shouldn't nta here.

	-hpa


