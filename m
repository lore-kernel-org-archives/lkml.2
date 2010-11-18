Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759729Ab0KRQQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:16:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757269Ab0KRQP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:15:59 -0500
Date: Thu, 18 Nov 2010 13:32:40 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 2/6] KVM: MMU: don't drop spte if overwrite it from W
 to RO
Message-ID: <20101118153240.GE14327@amt.cnet>
References: <4CE355A0.6020907@cn.fujitsu.com>
 <4CE355CA.80106@cn.fujitsu.com>
 <20101117154241.GB18959@amt.cnet>
 <4CE3FB74.8050705@redhat.com>
 <4CE4D1F8.7090701@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE4D1F8.7090701@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 03:12:56PM +0800, Xiao Guangrong wrote:
> On 11/17/2010 11:57 PM, Avi Kivity wrote:
> 
> >>>   set_pte:
> >>>       update_spte(sptep, spte);
> >>> +    /*
> >>> +     * If we overwrite a writable spte with a read-only one we
> >>> +     * should flush remote TLBs. Otherwise rmap_write_protect
> >>> +     * will find a read-only spte, even though the writable spte
> >>> +     * might be cached on a CPU's TLB.
> >>> +     */
> >>> +    if (is_writable_pte(entry)&&  !is_writable_pte(*sptep))
> >>> +        kvm_flush_remote_tlbs(vcpu->kvm);
> >> There is no need to flush on sync_page path since the guest is
> >> responsible for it.
> >>
> > 
> >  If we don't, the next rmap_write_protect() will incorrectly decide that
> > there's no need to flush tlbs.
> > 
> 
> Maybe it's not a problem if guest can flush all tlbs after overwrite it?
> Marcelo, what's your comment about this?

It can, but there is no guarantee. Your patch is correct.
