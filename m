Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab0C1RKW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 13:10:22 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57274 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab0C1RKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 13:10:18 -0400
Message-ID: <4BAF8D79.4090900@cs.helsinki.fi>
Date: Sun, 28 Mar 2010 20:10:17 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slub: Potential stack overflow
References: <1269430856.3213.27.camel@edumazet-laptop>	 <alpine.DEB.2.00.1003241414270.14329@router.home>	 <1269458528.2849.2.camel@edumazet-laptop>	 <alpine.DEB.2.00.1003241443520.14329@router.home>	 <1269464591.2849.15.camel@edumazet-laptop>	 <alpine.DEB.2.00.1003241608270.16858@router.home>	 <alpine.DEB.2.00.1003241613350.16858@router.home> <1269465947.2849.21.camel@edumazet-laptop>
In-Reply-To: <1269465947.2849.21.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Le mercredi 24 mars 2010 à 16:14 -0500, Christoph Lameter a écrit :
>> Here is a patch for the second case. I think its better since it results
>> in an error display and it avoids the alloc for each slab. Add this piece
>> to your patch?
>>
>> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
> 
> Sure, here is third version :
> 
> Thanks
> 
> [PATCH] slub: Potential stack overflow
> 
> I discovered that we can overflow stack if CONFIG_SLUB_DEBUG=y and use
> slabs with many objects, since list_slab_objects() and process_slab()
> use DECLARE_BITMAP(map, page->objects);
> 
> With 65535 bits, we use 8192 bytes of stack ...
> 
> Switch these allocations to dynamic allocations.
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Applied.
