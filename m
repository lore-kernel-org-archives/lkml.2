Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab2JPSCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 14:02:54 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:47933
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755124Ab2JPSCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 14:02:52 -0400
X-Forefront-Antispam-Report: CIP:160.33.194.230;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail03v.am.sony.com;RD:mail.sonyusa.com;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI9371I936eI1432Izz1202h1d1ah1d2ahzzz2fh2a8h668h839h93fhd25hf0ah107ah1288h12a5h12a9h12bdh137ah13b6h1441h1155h)
Message-ID: <507DA245.9050709@am.sony.com>
Date: Tue, 16 Oct 2012 11:07:01 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Ezequiel Garcia <elezegarcia@gmail.com>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "celinux-dev@lists.celinuxforum.org" 
	<celinux-dev@lists.celinuxforum.org>
Subject: Re: [Q] Default SLAB allocator
References: <CALF0-+XGn5=QSE0bpa4RTag9CAJ63MKz1kvaYbpw34qUhViaZA@mail.gmail.com>  <m27gqwtyu9.fsf@firstfloor.org>  <alpine.DEB.2.00.1210111558290.6409@chino.kir.corp.google.com>  <m2391ktxjj.fsf@firstfloor.org>  <CALF0-+WLZWtwYY4taYW9D7j-abCJeY90JzcTQ2hGK64ftWsdxw@mail.gmail.com>  <alpine.DEB.2.00.1210130252030.7462@chino.kir.corp.google.com>  <CALF0-+Xp_P_NjZpifzDSWxz=aBzy_fwaTB3poGLEJA8yBPQb_Q@mail.gmail.com>  <alpine.DEB.2.00.1210151745400.31712@chino.kir.corp.google.com>  <CALF0-+WgfnNOOZwj+WLB397cgGX7YhNuoPXAK5E0DZ5v_BxxEA@mail.gmail.com> <1350392160.3954.986.camel@edumazet-glaptop>
In-Reply-To: <1350392160.3954.986.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 05:56 AM, Eric Dumazet wrote:
> On Tue, 2012-10-16 at 09:35 -0300, Ezequiel Garcia wrote:
> 
>> Now, returning to the fragmentation. The problem with SLAB is that
>> its smaller cache available for kmalloced objects is 32 bytes;
>> while SLUB allows 8, 16, 24 ...
>>
>> Perhaps adding smaller caches to SLAB might make sense?
>> Is there any strong reason for NOT doing this?
> 
> I would remove small kmalloc-XX caches, as sharing a cache line
> is sometime dangerous for performance, because of false sharing.
> 
> They make sense only for very small hosts.

That's interesting...

It would be good to measure the performance/size tradeoff here.
I'm interested in very small systems, and it might be worth
the tradeoff, depending on how bad the performance is.  Maybe
a new config option would be useful (I can hear the groans now... :-)

Ezequiel - do you have any measurements of how much memory
is wasted by 32-byte kmalloc allocations for smaller objects,
in the tests you've been doing?
 -- Tim


=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

