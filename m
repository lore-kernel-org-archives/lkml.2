Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab0DOJse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 05:48:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069Ab0DOJsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 05:48:32 -0400
Message-ID: <4BC6E0D9.1090202@redhat.com>
Date: Thu, 15 Apr 2010 12:48:09 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: oerg Roedel <joro@8bytes.org>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com, Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH V3] perf & kvm: Enhance perf to collect KVM guest os	statistics
 from host side
References: <1902387910.2078.435.camel@ymzhang.sh.intel.com> <4BC588CF.5010507@redhat.com> <1902445479.2078.458.camel@ymzhang.sh.intel.com> <4BC6C8CD.1020801@redhat.com> <1902473858.2078.481.camel@ymzhang.sh.intel.com> <20100415090403.GA12697@8bytes.org> <4BC6D7C8.9060302@redhat.com> <20100415094407.GB12697@8bytes.org>
In-Reply-To: <20100415094407.GB12697@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2010 12:44 PM, oerg Roedel wrote:
>
>> So, we'd need something like the following:
>>
>>     if (exit == NMI)
>>         __get_cpu_var(nmi_vcpu) = vcpu;
>>
>>     stgi();
>>
>>     if (exit == NMI) {
>>         while (!nmi_handled())
>>             cpu_relax();
>>         __get_cpu_var(nmi_vcpu) = NULL;
>>     }
>>      
> Hmm, looks a bit complicated to me. The NMI should happen shortly after
> the stgi instruction. Interrupts are still disabled so we stay on this
> cpu. Can't we just set and erase the cpu_var at vcpu_load/vcpu_put time?
>
>    

That means an NMI that happens outside guest code (for example, in the 
mmu, or during the exit itself) would be counted as if in guest code.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

