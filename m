Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab1H2PtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 11:49:15 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:38842 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab1H2PtO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 11:49:14 -0400
MIME-Version: 1.0
Message-ID: <4be6abb6-7b82-4e64-9e27-cd0fe0c1e1b1@default>
Date: Mon, 29 Aug 2011 08:47:59 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>, JBeulich@novell.com,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, Chris Mason <chris.mason@oracle.com>,
        sjenning@linux.vnet.ibm.com, jackdachef@gmail.com, cyclonusj@gmail.com
Subject: RE: Subject: [PATCH V7 2/4] mm: frontswap: core code
References: <20110823145815.GA23190@ca-server1.us.oracle.com>
 <20110825150532.a4d282b1.kamezawa.hiroyu@jp.fujitsu.com>
 <d0b4c414-e90f-4ae0-9b70-fd5b54d2b011@default
 20110826091619.1ad27e9c.kamezawa.hiroyu@jp.fujitsu.com
 a2fc3885-b98d-4918-afcc-5eac083c7eb0@default>
In-Reply-To: <a2fc3885-b98d-4918-afcc-5eac083c7eb0@default>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4E5BB4CA.000A:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > My concern was race in counters. Even you allow race in frontswap_succ_puts++,
> >
> > Don't you need some lock for
> > 	sis->frontswap_pages++
> > 	sis->frontswap_pages--
> 
> Hmmm... OK, you've convinced me.  If this counter should be one and
> a race leaves it as zero, I think data corruption could result on
> a swapoff or partial swapoff.  And after thinking about it, I
> think I also need to check for locking on frontswap_set/clear
> as I don't think these bitfield modifiers are atomic.
> 
> Thanks for pointing this out.  Good catch!  I will need to
> play with this and test it so probably will not submit V8 until
> next week as today is a vacation day for me.

Silly me: Of course set_bit and clear_bit ARE atomic.  I will
post V8 later today with the only changes being frontswap_pages
is now a type atomic_t.

Thanks again for catching this, Kame!

Thanks,
Dan
