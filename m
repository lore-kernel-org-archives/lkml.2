Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab0EDJuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 05:50:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab0EDJuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 05:50:52 -0400
Message-ID: <4BDFEDFA.3090209@redhat.com>
Date: Tue, 04 May 2010 12:50:50 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/22] KVM: MMU: Track page fault data in struct vcpu
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com> <1272364712-17425-17-git-send-email-joerg.roedel@amd.com> <4BD6DF7C.1090203@redhat.com> <20100503163221.GB28950@amd.com> <4BDFD295.7000702@redhat.com> <20100504091157.GC28950@amd.com> <4BDFE6C2.2040601@redhat.com> <20100504093709.GE28950@amd.com> <4BDFECD1.8040109@redhat.com>
In-Reply-To: <4BDFECD1.8040109@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2010 12:45 PM, Avi Kivity wrote:
>
>
> Just a silly bug.  kvm_pdptr_read() can cause a guest memory read on 
> svm, in this case with the mmu lock taken.  I'll post something to fix 
> it.

I guess this was not reported because most svm machines have npt, and 
this requires npt=0 to trigger.  Nonpae paging disables npt, so you were 
hit.  Interestingly, nsvm makes it more likely to appear, since npt on 
i386+pae will need the pdptrs.

-- 
error compiling committee.c: too many arguments to function

