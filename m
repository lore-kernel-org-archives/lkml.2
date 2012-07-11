Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab2GKLvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 07:51:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554Ab2GKLvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 07:51:39 -0400
Message-ID: <4FFD68C3.7000504@redhat.com>
Date: Wed, 11 Jul 2012 14:51:31 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Alex Williamson <alex.williamson@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>, "gleb@redhat.com" <gleb@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] kvm: level irqfd and new eoifd
References: <20120703191106.6735.78272.stgit@bling.home> <4FFD4D0A.2000202@redhat.com> <4FFD52E7.3030806@siemens.com> <4FFD5A2B.2040605@redhat.com> <4FFD6221.1060304@siemens.com>
In-Reply-To: <4FFD6221.1060304@siemens.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2012 02:23 PM, Jan Kiszka wrote:
>> 
>> I'd appreciate a couple of examples for formality's sake.
> 
> From the top of my head: NVIDIA FX3700 (granted, legacy by now), Atheros
> AR9287. For others, I need to check.

Thanks.

>> 
>>> And then there is not easily replaceable legacy hardware like old
>>> telephony adapters or industrial I/O cards etc. that want this.
>> 
>> I imagine legacy hardware will live with the speed of routing through
>> qemu, when running on modern platforms.
> 
> Just because it's "legacy" doesn't mean it's "low performance" and "low
> interrupt rate".

I meant that it was used with lower throughput hardware, so the overhead
of routing through qemu will be masked by the improved host hardware.
But most of the improvement in hardware in recent years is the increase
in core/thread count.

> We still have classic KVM device assignment to provide fast-path INTx.
> But if we want to replace it midterm, I think it's necessary for VFIO to
> be able to provide such a path as well.

I would like VFIO to have no regressions vs. kvm device assignment,
except perhaps in uncommon corner cases.  So I agree.

-- 
error compiling committee.c: too many arguments to function


