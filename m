Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab0K3TVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:21:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756193Ab0K3TVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:21:04 -0500
Date: Tue, 30 Nov 2010 21:20:59 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] KVM: MMU: fix accessed bit set on prefault path
Message-ID: <20101130192059.GC2924@redhat.com>
References: <4CF4C535.8080405@cn.fujitsu.com>
 <4CF4C587.7080000@cn.fujitsu.com>
 <20101130132915.GG2187@redhat.com>
 <4CF52BC6.9020401@cn.fujitsu.com>
 <20101130175005.GA2924@redhat.com>
 <4CF53F41.1040503@cn.fujitsu.com>
 <20101130183833.GB2924@redhat.com>
 <4CF54C4F.80901@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF54C4F.80901@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 03:11:11AM +0800, Xiao Guangrong wrote:
> On 12/01/2010 02:38 AM, Gleb Natapov wrote:
> 
> >> It can't avoid the page to be evicted again since the page is marked accessed only
> >> when spte is droped or updated.
> > I still do not understand why are you disabling prefault for ept. Why
> > do you want to distinguish between actually accessed translations and
> > prefauls? What problem are you trying to fix?
> > 
> 
> Look at set_spte_track_bits() function:
> 
> 	if (!shadow_accessed_mask || old_spte & shadow_accessed_mask)
> 		kvm_set_pfn_accessed(pfn);
> 
> It's always mark the page accessed.
> 
> But prefault is the speculative path, the prefault address may not be
> accessed later(the apf process is killed). under this case, the page is
> not really accessed.
Firs of all if guest is PV the guest process cannot be killed. Second
why is it a problem that we marked pfn as accessed on speculative path?
What problem it causes especially since it is very likely that the page
will be accessed shortly anyway?

--
			Gleb.
