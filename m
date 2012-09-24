Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab2IXLYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 07:24:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459Ab2IXLYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 07:24:19 -0400
Date: Mon, 24 Sep 2012 13:24:16 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 1/7] KVM: MMU: fix release noslot pfn
Message-ID: <20120924112416.GA23096@redhat.com>
References: <505C0FA8.5070007@linux.vnet.ibm.com>
 <505C0FCF.2070308@linux.vnet.ibm.com>
 <20120923091335.GA20907@redhat.com>
 <505FE8B4.8030309@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505FE8B4.8030309@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 12:59:32PM +0800, Xiao Guangrong wrote:
> On 09/23/2012 05:13 PM, Gleb Natapov wrote:
> > On Fri, Sep 21, 2012 at 02:57:19PM +0800, Xiao Guangrong wrote:
> >> We can not directly call kvm_release_pfn_clean to release the pfn
> >> since we can meet noslot pfn which is used to cache mmio info into
> >> spte
> >>
> > Wouldn't it be better to move the check into kvm_release_pfn_clean()?
> 
> I think there is no reason for us to prefer to adding this branch in
> the common code. :)

Is the function performance critical? Is function called without the check
on a hot path?  The function already contains much heavier kvm_is_mmio_pfn()
check. If most/all function invocation require check before call it's
better to move it inside.
 
--
			Gleb.
