Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab1GHBd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 21:33:27 -0400
Received: from mail.lang.hm ([64.81.33.126]:36564 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658Ab1GHBd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 21:33:26 -0400
Date: Thu, 7 Jul 2011 18:32:17 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Pekka Enberg <penberg@kernel.org>
cc: Ankita Garg <ankita@in.ibm.com>, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, svaidy@linux.vnet.ibm.com,
        thomas.abraham@linaro.org, Dave Hansen <dave@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 00/10] mm: Linux VM Infrastructure to support Memory
 Power Management
In-Reply-To: <alpine.DEB.2.00.1107072058390.5978@tiger>
Message-ID: <alpine.DEB.2.02.1107071831250.8081@asgard.lang.hm>
References: <1306499498-14263-1-git-send-email-ankita@in.ibm.com> <20110629130038.GA7909@in.ibm.com> <CAOJsxLHQP=-srK_uYYBsPb7+rUBnPZG7bzwtCd-rRaQa4ikUFg@mail.gmail.com> <alpine.DEB.2.02.1107061318190.2535@asgard.lang.hm>
 <alpine.DEB.2.00.1107072058390.5978@tiger>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jul 2011, Pekka Enberg wrote:

> On Wed, 6 Jul 2011, Pekka Enberg wrote:
>>> Why does the allocator need to know about address boundaries? Why
>>> isn't it enough to make the page allocator and reclaim policies favor 
>>> using
>>> memory from lower addresses as aggressively as possible? That'd mean
>>> we'd favor the first memory banks and could keep the remaining ones
>>> powered off as much as possible.
>>> 
>>> IOW, why do we need to support scenarios such as this:
>>>
>>>   bank 0     bank 1   bank 2    bank3
>>> | online  | offline | online  | offline |
>> 
> On Wed, 6 Jul 2011, david@lang.hm wrote:
>> I believe that there are memory allocations that cannot be moved after they 
>> are made (think about regions allocated to DMA from hardware where the 
>> hardware has already been given the address space to DMA into)
>> 
>> As a result, you may not be able to take bank 2 offline, so your option is 
>> to either leave banks 0-2 all online, or support emptying bank 1 and taking 
>> it offline.
>
> But drivers allocate DMA memory for hardware during module load and stay 
> pinned there until the driver is unloaded, no? So in practice DMA buffers are 
> going to be in banks 0-1?

that depends on when the device was initialized. it is common for them to 
be in the beginning, but with hotplug, who knows.

David Lang
