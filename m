Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab2E2OXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 10:23:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363Ab2E2OXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 10:23:39 -0400
Message-ID: <4FC4DBE6.1040703@redhat.com>
Date: Tue, 29 May 2012 17:23:34 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: MMU: fix huge page adapted on non-PAE host
References: <4FC316E3.6080607@linux.vnet.ibm.com> <4FC35A15.6080000@redhat.com> <4FC363EE.6060204@linux.vnet.ibm.com> <4FC36E85.4010909@redhat.com> <4FC37600.1060301@linux.vnet.ibm.com> <4FC37A18.10809@redhat.com> <4FC38084.40409@linux.vnet.ibm.com> <4FC38362.6010802@redhat.com> <20120528143221.GF4016@redhat.com> <4FC38E48.9080701@redhat.com> <20120528144439.GH4016@redhat.com>
In-Reply-To: <20120528144439.GH4016@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2012 05:44 PM, Andrea Arcangeli wrote:
> On Mon, May 28, 2012 at 05:40:08PM +0300, Avi Kivity wrote:
>> Yes, I see it now.  Adjusting mask is incorrect since we won't have the
>> same adjustment on release.  I'll apply the patch for 3.5.
> 
> Sounds great to me. One thing I'm not sure about is about the real need of
> the mmio check vs a stright get_page (we shouldn't ever get to a gup-fast
> succeeding if this was a mmio region?) but I don't see chances that it
> could hurt either.

This is a device assignment mmio region.  gpu_fast() can succeed is we
happen to have a struct page for it (pci hole) or fail if we don't
(64-bit BAR).  See hva_to_pfn() (and indeed this is the reason we use
pfns instead of struct pages).

-- 
error compiling committee.c: too many arguments to function
