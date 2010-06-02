Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996Ab0FBM2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 08:28:40 -0400
Received: from smtp.nokia.com ([192.100.122.230]:44981 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757771Ab0FBM2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 08:28:38 -0400
Date: Wed, 02 Jun 2010 15:28:26 +0300 (EEST)
Message-Id: <20100602.152826.35036625.Hiroshi.DOYU@nokia.com>
To: catalin.marinas@arm.com
Cc: linux-kernel@vger.kernel.org, ext-phil.2.carmody@nokia.com,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 0/3] kmemleak: Fix false positive with special scan
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
In-Reply-To: <20100602.143458.232754971.Hiroshi.DOYU@nokia.com>
References: <1275387911-13030-1-git-send-email-Hiroshi.DOYU@nokia.com>
	<1275472884.13743.29.camel@e102109-lin.cambridge.arm.com>
	<20100602.143458.232754971.Hiroshi.DOYU@nokia.com>
X-Mailer: Mew version 6.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jun 2010 12:28:26.0826 (UTC) FILETIME=[19C5DAA0:01CB024F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: Re: [PATCH v2 0/3] kmemleak: Fix false positive with special scan
Date: Wed, 02 Jun 2010 14:34:58 +0300 (EEST)

> From: ext Catalin Marinas <catalin.marinas@arm.com>
> Subject: Re: [PATCH v2 0/3] kmemleak: Fix false positive with special scan
> Date: Wed, 2 Jun 2010 12:01:24 +0200
> 
>> Hi,
>> 
>> Sorry for the delay, I eventually got the time to look at your patches.
> 
> Thank you for your review.
> 
>> On Tue, 2010-06-01 at 11:25 +0100, Hiroshi DOYU wrote:
>>> There is a false positive case that a pointer is calculated by other
>>> methods than the usual container_of macro. "kmemleak_ignore" can cover
>>> such a false positive, but it would loose the advantage of memory leak
>>> detection. This patch allows kmemleak to work with such false
>>> positives by introducing a new special memory block with a specified
>>> calculation formula. A client module can register its area with a
>>> conversion function, with which function kmemleak scan could calculate
>>> a correct pointer.
>> 
>> While something needs to be done to cover these situations, I'm not so
>> convinced about the method as it complicates the code requiring such
>> conversion by having to insert two kmemleak hooks and a callback
>> function.
>>
>> Can we not add a new prio tree (or just use the existing one) for
>> pointer aliases? The advantage is that you only have a single function
>> to call, something like kmemleak_add_alias() and you do it at the point
>> the value was converted.

Ok, I understand now. Please ignore my previous. I'll try the above.
