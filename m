Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab0K3Sii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 13:38:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab0K3Sih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 13:38:37 -0500
Date: Tue, 30 Nov 2010 20:38:33 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] KVM: MMU: fix accessed bit set on prefault path
Message-ID: <20101130183833.GB2924@redhat.com>
References: <4CF4C535.8080405@cn.fujitsu.com>
 <4CF4C587.7080000@cn.fujitsu.com>
 <20101130132915.GG2187@redhat.com>
 <4CF52BC6.9020401@cn.fujitsu.com>
 <20101130175005.GA2924@redhat.com>
 <4CF53F41.1040503@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF53F41.1040503@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 02:15:29AM +0800, Xiao Guangrong wrote:
> On 12/01/2010 01:50 AM, Gleb Natapov wrote:
> > On Wed, Dec 01, 2010 at 12:52:22AM +0800, Xiao Guangrong wrote:
> >> On 11/30/2010 09:29 PM, Gleb Natapov wrote:
> >>
> >>>> +	if (!shadow_accessed_mask)
> >>>> +		return;
> >>>> +
> >>> I don't get this. As far as I can see VMX inits shadow_accessed_mask to
> >>> be zero if ept is enabled. This line here means that we never prefault with ept
> >>> enabled. It is opposite from what it should be.
> >>>
> >>
> >> Since it's no accessed bit on EPT, it's no way to distinguish between actually
> >> accessed translations and prefault.
> > Why is this a problem? We do what this page to not be evicted again
> > since we expect it to be accessed.
> > 
> 
> It can't avoid the page to be evicted again since the page is marked accessed only
> when spte is droped or updated.
I still do not understand why are you disabling prefault for ept. Why
do you want to distinguish between actually accessed translations and
prefauls? What problem are you trying to fix?

--
			Gleb.
