Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab0KOJ45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 04:56:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869Ab0KOJ44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 04:56:56 -0500
Date: Mon, 15 Nov 2010 11:56:51 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] KVM: MMU: retry #PF for softmmu
Message-ID: <20101115095651.GI7948@redhat.com>
References: <4CDCE2B0.7000601@cn.fujitsu.com>
 <4CDCE3C2.9030107@cn.fujitsu.com>
 <4CDFBE00.2000802@redhat.com>
 <4CE0C45C.809@cn.fujitsu.com>
 <4CE0FDBC.20505@redhat.com>
 <4CE1038D.9020403@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE1038D.9020403@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 05:55:25PM +0800, Xiao Guangrong wrote:
> On 11/15/2010 05:30 PM, Avi Kivity wrote:
> 
> >> Yeah, this 'retry' is unnecessary if the process is killed, but this
> >> case is infrequent, the most case is the process keeps running and try
> >> to access the fault address later.
> > 
> > The problem is that if we retry in this case, we install an incorrect spte?
> > 
> 
> ......
> 
> >> can avoid if the page mapping have been fixed.
> > 
> > The guest may have changed page directories or other levels.
> > 
> 
> ......
> 
> >> >  Or another thread may have mmap()ed something else over the
> >> >  same address.
> >>
> >> The mmap virtual address is also visible for other threads since the
> >> threads
> >> have the same page table, so i think this case is the same as above?
> > 
> > Again, don't we install the wrong spte in this case?
> > 
> 
> I think it doesn't corrupts spte since we will walk guest page table again
> and map it to shadow pages when we retry #PF.
But if the page is not mapped by new process we can inject #PF into a
guest.

--
			Gleb.
