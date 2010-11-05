Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab0KEKbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 06:31:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab0KEKb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 06:31:28 -0400
Date: Fri, 5 Nov 2010 12:31:24 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: MMU: don not retry #PF for nonpaging guest
Message-ID: <20101105103124.GD14910@redhat.com>
References: <4CD28B5F.1040205@cn.fujitsu.com>
 <4CD28BCA.1060907@cn.fujitsu.com>
 <20101104103548.GE6018@redhat.com>
 <4CD39886.4050909@cn.fujitsu.com>
 <20101105074533.GC14910@redhat.com>
 <4CD3BA50.1000002@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD3BA50.1000002@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 04:03:28PM +0800, Xiao Guangrong wrote:
> On 11/05/2010 03:45 PM, Gleb Natapov wrote:
> 
> >>
> >> It looks like something broken: apfs can generated in L2 guest (nested ntp guest)
> >> and be retried in L1 guest.
> >>
> > Why is this a problem? apf will be generate on direct map even when L2
> > guest is running so it should be OK to prefault it into direct map on
> > completion.
> > 
> 
> The nested_cr3 is different between L2 and L1, fix L2's page fault in L1's page table
> is useless.
But we are fixing L0 page faults in L0 page table. We do not start apf
because of L1 faulted in its page table.

--
			Gleb.
