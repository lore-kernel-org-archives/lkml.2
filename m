Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab1DHNXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 09:23:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47897 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab1DHNXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 09:23:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=Wz1Eq2ERm3VrXa60LATIR9oSzTjQe1/TaprZa1TcBbyTqEUB8N39v4M8ZjnSlfYasO
         HDQFSkI47DLuHv6qzwUtIRdWT1gb7jMM4IrrAW/DwB5iSKqufGhLpjEuLFr4eR/ekM9t
         g4YyBUHbsraTBjAubAY8PQcC5Aih0XjMv6mLs=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Dave Hansen" <dave@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "Timur Tabi" <timur@freescale.com>, "Andi Kleen" <andi@firstfloor.org>,
        "Mel Gorman" <mel@csn.ul.ie>,
        "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] make new alloc_pages_exact()
References: <20110407172104.1F8B7329@kernel> <20110407172105.831B9A0A@kernel>
 <op.vtmcx9kd3l0zgt@mnazarewicz-glaptop> <1302268786.8184.6879.camel@nimitz>
Date: Fri, 08 Apr 2011 15:23:40 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vtmfhqyh3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1302268786.8184.6879.camel@nimitz>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Thu, 07 Apr 2011 19:21:05 +0200, Dave Hansen wrote:
>>>  		while (used < alloc_end) {
>>> -			free_page(used);
>>> -			used += PAGE_SIZE;
>>> +			__free_page(used);
>>> +			used++;
>>>  		}

> On Fri, 2011-04-08 at 14:28 +0200, Michal Nazarewicz wrote:
>> Have you thought about moving this loop to a separate function, ie.
>> _free_page_range(start, end)?  I'm asking because this loop appears
>> in two places and my CMA would also benefit from such a function.

On Fri, 08 Apr 2011 15:19:46 +0200, Dave Hansen wrote:
> Sounds like a good idea to me.  Were you thinking start/end 'struct
> page's as arguments?

Either that or (struct page *start, unsigned nr_pages).

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
