Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab0ESFXC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 01:23:02 -0400
Received: from smtp126.mail.ukl.yahoo.com ([77.238.184.57]:41864 "HELO
	smtp126.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751289Ab0ESFXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 01:23:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.es;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=ZGPf/6ZXpn7uzv6zIMamxDDEJu2guCPM/rD+diPjp9bgSDoVltO3oeCaFZ8ioHWLv0JcrzUL+Kcc/w1Yn52kgFF7IOfMd6+XFw8wwiWB1a4v1+o8IxnhZB8GwHzLFG0RMsJxqEEgkV1YnCm55seq6FNvxS/mIW01dybGxFxaQPI=  ;
X-Yahoo-SMTP: czee06uswBAtfIYshc.kP27UlfEXaxwWNSjJ
X-YMail-OSG: N1O.b5oVM1n0yLhXHar2cKu93OwU70kUrgLfGDfVNwpLp0TYjx4wa6o0xOwVRCSTHkcabp7.aRpS9U1X7J.sRlKzrE6ADbA8CxcNzGHzpowY7iAZvfutge_eGH3dVOOUICAvxO5jwgiTAUKED3qMieGJhEL2Qyveijuw9RYc6vgwUxoROZBwi_nrdUQStf89UdD64ij5jv19Aoizy90lPmb9r4N13KhCq6e_fIMIES8pAljkasde0u.Rt.lTuX3W
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4BF375AE.7060901@yahoo.es>
Date: Wed, 19 May 2010 07:22:54 +0200
From: Albert Herranz <albert_herranz@yahoo.es>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: konrad.wilk@oracle.com, Ian.Campbell@eu.citrix.com, jeremy@goop.org,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       iommu@lists.linux-foundation.org, dwmw2@infradead.org,
       linux@arm.linux.org.uk
Subject: Re: [PATCH 5/6] swiotlb: Make swiotlb bookkeeping functions visible
 in the header file.
References: <4BEB884B.7030402@yahoo.es>	<20100518123010G.fujita.tomonori@lab.ntt.co.jp>	<4BF2C5C1.2020807@yahoo.es> <20100519123626P.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100519123626P.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2010 05:34 AM, FUJITA Tomonori wrote:
>> Every single KB counts on the Wii. It has just 24MB of MEM1 and 64MB of MEM2 (discontiguous memory ranges).
>> I'm using 1MB for the SWIOTLB for now, but of course that can be further tweaked down.
> 
> You can decrease the swiotlb memory however you can't fix the root
> problems of swiotlb:
> 
> - it needs pre-allocated memory
> - it can't handle the out-of-pre-allocated memory situation.
> 

Yes, agreed.
Although having a dedicated pool _may_ be an advantage on a memory constrained system: it can guarantee swiotlb allocations (as long as the pool has been properly sized) even when the system is using up all memory.

> I mean that Wii doesn't boot on the root device on the USB controller,
> right?
> 

The current "bootloaders" boot images from the external SD card.
But Linux itself can have its root device on a USB storage device.

>> I posted (in the past) a patch series [1] in which I made the
>> dmabounce code in the ARM architecture tree available to other
>> architectures, and used that to implement the needed bouncing
>> infrastructure.  But I was told then by Russell to use swiotlb
>> instead [2].
> 
> I think that we need to modify swiotlb for embedded archs. Otherwise,
> I don't think that swiotlb can replace arm's dmabounce.
> 
> Ok, I'll implement something like that.
> 

Thanks. Looking forward to it :)

Cheers,
Albert
