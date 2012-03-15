Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032227Ab2COTv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 15:51:59 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34107 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031828Ab2COTv4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 15:51:56 -0400
MIME-Version: 1.0
Message-ID: <33e296c5-825f-44a2-8f42-e76caf3715a6@default>
Date: Thu, 15 Mar 2012 12:51:43 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Akshay Karle <akshay.a.karle@gmail.com>,
        Konrad Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        ashu tripathi <er.ashutripathi@gmail.com>,
        nishant gulhane <nishant.s.gulhane@gmail.com>,
        Shreyas Mahure <shreyas.mahure@gmail.com>,
        amarmore2006 <amarmore2006@gmail.com>,
        mahesh mohan <mahesh6490@gmail.com>
Subject: RE: [RFC 1/2] kvm: host-side changes for tmem on KVM
References: <1331225648.2585.27.camel@aks>
 <20120315165400.GL30250@phenom.dumpdata.com> <1331836868.2215.43.camel@aks>
In-Reply-To: <1331836868.2215.43.camel@aks>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4F62485B.0062,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Akshay Karle [mailto:akshay.a.karle@gmail.com]
> Subject: Re: [RFC 1/2] kvm: host-side changes for tmem on KVM
> 
> >> @@ -669,7 +670,6 @@ static struct zv_hdr *zv_create(struct x
> >>       int chunks = (alloc_size + (CHUNK_SIZE - 1)) >> CHUNK_SHIFT;
> >>       int ret;
> >>
> >> -     BUG_ON(!irqs_disabled());
> >
> > Can you explain why?
> 
> Zcache is by default used in the non-virtualized environment for page compression. Whenever
> a page is to be evicted from the page cache the spin_lock_irq is held on the page mapping.
> To ensure that this is done, the BUG_ON(!irqs_disabled()) was used.
> But now the situation is different, we are using zcache functions for kvm VM's.
> So if any page of the guest is to be evicted the irqs should be disabled in just that
> guest and not the host, so we removed the BUG_ON(!irqs_disabled()); line.

I think irqs may still need to be disabled (in your code by the caller)
since the tmem code (in tmem.c) takes spinlocks with this assumption.
I'm not sure since I don't know what can occur with scheduling a
kvm guest during an interrupt... can a different vcpu of the same guest
be scheduled on this same host pcpu?

Dan
