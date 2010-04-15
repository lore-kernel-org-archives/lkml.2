Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab0DOKol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 06:44:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab0DOKok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 06:44:40 -0400
Message-ID: <4BC6EDFF.3000702@redhat.com>
Date: Thu, 15 Apr 2010 13:44:15 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com, Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH V3] perf & kvm: Enhance perf to collect KVM guest os	statistics
 from host side
References: <1902387910.2078.435.camel@ymzhang.sh.intel.com> <4BC588CF.5010507@redhat.com> <1902445479.2078.458.camel@ymzhang.sh.intel.com> <4BC6C8CD.1020801@redhat.com> <1902473858.2078.481.camel@ymzhang.sh.intel.com> <20100415090403.GA12697@8bytes.org> <4BC6D7C8.9060302@redhat.com> <20100415094407.GB12697@8bytes.org> <4BC6E0D9.1090202@redhat.com> <20100415104051.GC12697@8bytes.org>
In-Reply-To: <20100415104051.GC12697@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2010 01:40 PM, Joerg Roedel wrote:
>
>> That means an NMI that happens outside guest code (for example, in the
>> mmu, or during the exit itself) would be counted as if in guest code.
>>      
> Hmm, true. The same is true for an NMI that happens between VMSAVE and
> STGI but that window is smaller. Anyway, I think we don't need the
> busy-wait loop. The NMI should be executed at a well defined point and
> we set the cpu_var back to NULL after that point.
>    

The point is not well defined.  Considering there are already at least 
two implementations svm, I don't want to rely on implementation details.

We could tune the position of the loop so that zero iterations are 
executed on the implementations we know about.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

