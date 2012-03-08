Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809Ab2CHPri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 10:47:38 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:57062 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757401Ab2CHPrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 10:47:35 -0500
Message-ID: <4F58D48F.8050807@de.ibm.com>
Date: Thu, 08 Mar 2012 16:47:27 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Lightning/1.0b2 Thunderbird/3.1.19
MIME-Version: 1.0
To: Davidlohr Bueso <dave@gnu.org>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        KVM <kvm@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: x86: add paging gcc optimization
References: <1331207154.28711.2.camel@offworld>
In-Reply-To: <1331207154.28711.2.camel@offworld>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12030815-3548-0000-0000-00000148C234
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/12 12:45, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <dave@gnu.org>
> 
> Since most guests will have paging enabled for memory management, add likely() optimization
> around CR0.PG checks.

>  {
> -	return kvm_read_cr0_bits(vcpu, X86_CR0_PG);
> +	return likely(kvm_read_cr0_bits(vcpu, X86_CR0_PG));


IMHO likely/unlikely should be considered more as fast-path/slow-path and not as often/less often.
Is that the case here? This patch  might cause a mis-prediction for non-paging guests all 
the time. 

Non-paging might be really irrelevant, so I am just making a point, since
likely/unlikely is mis-used too often especially for "most users do it that way".


Christian

