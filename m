Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab0DTDdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 23:33:12 -0400
Received: from mga05.intel.com ([192.55.52.89]:47439 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753116Ab0DTDdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 23:33:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,239,1270450800"; 
   d="scan'208";a="559539993"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH V3] perf & kvm: Enhance perf to collect KVM guest  os statistics from host side
Date: Tue, 20 Apr 2010 11:32:55 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-20-generic; KDE/4.3.2; x86_64; ; )
Cc: Joerg Roedel <joro@8bytes.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com, Arnaldo Carvalho de Melo <acme@infradead.org>
References: <1902387910.2078.435.camel@ymzhang.sh.intel.com> <4BC9FA19.2070602@redhat.com> <4BCC136D.503@redhat.com>
In-Reply-To: <4BCC136D.503@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201004201132.56039.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 April 2010 16:25:17 Avi Kivity wrote:
> On 04/17/2010 09:12 PM, Avi Kivity wrote:
> > I think you were right the first time around.
> 
> Re-reading again (esp. the part about treatment of indirect NMI
> vmexits), I think this was wrong, and that the code is correct.  I am
> now thoroughly confused.
> 
My fault...

To my understanding now, "If an event causes a VM exit directly, it does not 
update architectural state as it would have if it had it not caused the VM 
exit:", means: in NMI case, NMI would involve the NMI handler, and change the 
"architectural state" to NMI block. In VMX non-root mode, the behavior of 
calling NMI handler changed(determine by some VMCS fields), but not the 
affection to the "architectural state". So the NMI block state would remain 
the same.

-- 
regards
Yang, Sheng
