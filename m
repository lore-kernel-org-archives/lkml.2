Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab2DOLZj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 07:25:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab2DOLZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 07:25:38 -0400
Message-ID: <4F8AB02A.9020601@redhat.com>
Date: Sun, 15 Apr 2012 14:25:30 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 04/16] KVM: MMU: return bool in __rmap_write_protect
References: <4F87FA69.5060106@linux.vnet.ibm.com> <4F87FBC1.5010907@linux.vnet.ibm.com> <20120414110031.38450bebfe712215f01d529f@gmail.com>
In-Reply-To: <20120414110031.38450bebfe712215f01d529f@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2012 05:00 AM, Takuya Yoshikawa wrote:
> On Fri, 13 Apr 2012 18:11:13 +0800
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
>
> > The reture value of __rmap_write_protect is either 1 or 0, use
> > true/false instead of these
>
> ...
>
> > @@ -1689,7 +1690,7 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
> > 
> >  	kvm_mmu_pages_init(parent, &parents, &pages);
> >  	while (mmu_unsync_walk(parent, &pages)) {
> > -		int protected = 0;
> > +		bool protected = false;
> > 
> >  		for_each_sp(pages, sp, parents, i)
> >  			protected |= rmap_write_protect(vcpu->kvm, sp->gfn);
>
> Isn't this the reason we prefer int to bool?
>
> Not sure people like to use |= with boolean.
>

Why not?

-- 
error compiling committee.c: too many arguments to function

