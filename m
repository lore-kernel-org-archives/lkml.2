Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab0CRF2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 01:28:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:38626 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab0CRF2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 01:28:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,264,1267430400"; 
   d="scan'208";a="501567289"
From: "Huang, Zhiteng" <zhiteng.huang@intel.com>
To: Avi Kivity <avi@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>
CC: Anthony Liguori <aliguori@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
Date: Thu, 18 Mar 2010 13:27:40 +0800
Subject: RE: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
Thread-Topic: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
Thread-Index: AcrFhb8B9VmStT8jThWVCcWcUWUj7AA0j0PA
Message-ID: <CE761E84DADF2947A4AF22FB8D97A4731C7B48FF@shsmsx501.ccr.corp.intel.com>
References: <20100316130840.GA24808@elte.hu> <4B9F84C0.70706@redhat.com>
 <20100316133114.GB575@elte.hu> <y0mbpeo1f1y.fsf@fche.csb>
 <20100316155221.GA19699@elte.hu> <4B9FC11A.1070507@linux.vnet.ibm.com>
 <20100316175243.GC23859@elte.hu> <4B9FC8B2.6070404@linux.vnet.ibm.com>
 <20100316182809.GA26602@elte.hu> <4BA00E6A.7080903@linux.vnet.ibm.com>
 <20100317004136.GC17472@redhat.com> <4BA05285.3070903@redhat.com>
In-Reply-To: <4BA05285.3070903@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o2I5SKmE014539

Hi Avi, Ingo,

I've been following through this long thread since the very first email.  

I'm a performance engineer whose job is to tune workloads run on top of KVM (and Xen previously).  As a performance engineer, I desperately want to have a tool that can monitor the host and guests at same time.  Think about >100 guests mixed with Linux/Windows running together on single system, being able to know what's happening is critical to do performance analysis.   Actually I am the person asked Yanmin to add feature for CPU utilization break down (into host_usr, host_krn, guest_usr, guest_krn) so that I can monitor dozens of running guests.   I hasn't made this patch work on my system yet but I _do_ think this patch is a very good start.  

And finally, monitoring guests from host is useful for users too (administrator and performance guy like me).   I really appreciate you guys' work and would love to provide feedback from my point of view if needed.


Regards,

HUANG, Zhiteng

Intel SSG/SSD/SPA/PRC Scalability Lab


-----Original Message-----
From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On Behalf Of Avi Kivity
Sent: Wednesday, March 17, 2010 11:55 AM
To: Frank Ch. Eigler
Cc: Anthony Liguori; Ingo Molnar; Zhang, Yanmin; Peter Zijlstra; Sheng Yang; linux-kernel@vger.kernel.org; kvm@vger.kernel.org; Marcelo Tosatti; oerg Roedel; Jes Sorensen; Gleb Natapov; Zachary Amsden; ziteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from host side

On 03/17/2010 02:41 AM, Frank Ch. Eigler wrote:
> Hi -
>
> On Tue, Mar 16, 2010 at 06:04:10PM -0500, Anthony Liguori wrote:
>    
>> [...]
>> The only way to really address this is to change the interaction.
>> Instead of running perf externally to qemu, we should support a perf
>> command in the qemu monitor that can then tie directly to the perf
>> tooling.  That gives us the best possible user experience.
>>      
> To what extent could this be solved with less crossing of
> isolation/abstraction layers, if the perfctr facilities were properly
> virtualized?
>    

That's the more interesting (by far) usage model.  In general guest 
owners don't have access to the host, and host owners can't (and 
shouldn't) change guests.

Monitoring guests from the host is useful for kvm developers, but less 
so for users.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

--
To unsubscribe from this list: send the line "unsubscribe kvm" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
