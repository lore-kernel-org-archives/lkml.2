Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161308Ab2COTIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 15:08:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161254Ab2COTIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 15:08:19 -0400
Message-ID: <4F6230B1.4010004@redhat.com>
Date: Thu, 15 Mar 2012 20:10:57 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Akshay Karle <akshay.a.karle@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, ashu tripathi <er.ashutripathi@gmail.com>,
        nishant gulhane <nishant.s.gulhane@gmail.com>,
        amarmore2006 <amarmore2006@gmail.com>,
        Shreyas Mahure <shreyas.mahure@gmail.com>,
        mahesh mohan <mahesh6490@gmail.com>
Subject: Re: [RFC 0/2] kvm: Transcendent Memory (tmem) on KVM
References: <1331224181.2585.16.camel@aks> <4F621FC0.7050800@redhat.com> <ac318852-4ccd-4739-893c-52f5cddee6c7@default> <4F622E90.5080001@redhat.com> <20120315180233.GF452@phenom.dumpdata.com>
In-Reply-To: <20120315180233.GF452@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2012 08:02 PM, Konrad Rzeszutek Wilk wrote:
> > 
> > Nice.  This takes care of the tail-end of the streaming (the more
> > important one - since it always involves a cold copy).  What about the
> > other side?  Won't the read code invoke cleancache_get_page() for every
> > page? (this one is just a null hypercall, so it's cheaper, but still
> > expensive).
>
> That is something we should fix - I think it was mentioned in the frontswap
> email thread the need for batching and it certainly seems required as those
> hypercalls aren't that cheap.

In fact when tmem was first proposed I asked for two changes - make it
batchable, and make it asynchronous (so we can offload copies to a dma
engine, etc).  Of course that would have made tmem significantly more
complicated.

-- 
error compiling committee.c: too many arguments to function

