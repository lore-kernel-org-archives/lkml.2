Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab0D0QC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 12:02:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538Ab0D0QCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 12:02:25 -0400
Message-ID: <4BD70A8E.2070906@redhat.com>
Date: Tue, 27 Apr 2010 19:02:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/22] KVM: MMU: Track page fault data in struct vcpu
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com> <1272364712-17425-17-git-send-email-joerg.roedel@amd.com> <4BD6DF7C.1090203@redhat.com> <20100427132801.GI11097@amd.com> <4BD6E8A6.5040008@redhat.com> <20100427135700.GK11097@amd.com>
In-Reply-To: <20100427135700.GK11097@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2010 04:57 PM, Joerg Roedel wrote:
>
>> But the nested guest can use pae paging and generate a #NPF with
>> exit_info_2>  4GB.  So we need to keep the full fault address; if we
>> truncate, the guest might actually resolve the fault and let the
>> nested guest continue.
>>      
> This could only be a malicious guest because it can't have memory above
> 4gb. But a guest could certainly setup its page tables to point there,
> thats true. So I change it to u64.
>    

It doesn't need to be malicious, for example it could set up an mmio PCI 
BAR outside the 4GB space.

-- 
error compiling committee.c: too many arguments to function

