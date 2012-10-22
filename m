Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab2JVNGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:06:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab2JVNGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:06:08 -0400
Date: Mon, 22 Oct 2012 15:05:58 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: fix vcpu->mmio_fragments overflow
Message-ID: <20121022130558.GV29310@redhat.com>
References: <20121022112314.GO29310@redhat.com>
 <50852F9C.9020808@siemens.com>
 <20121022114311.GQ29310@redhat.com>
 <508531E1.2030307@siemens.com>
 <508539A8.40404@redhat.com>
 <50853FF1.8010809@siemens.com>
 <20121022125301.GS29310@redhat.com>
 <5085423C.2020908@redhat.com>
 <20121022130102.GU29310@redhat.com>
 <508543DE.3080504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508543DE.3080504@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 03:02:22PM +0200, Avi Kivity wrote:
> On 10/22/2012 03:01 PM, Gleb Natapov wrote:
> 
> >> It's time where the guest cannot take interrupts, and time in a high
> >> priority guest thread that is spent processing low guest priority requests.
> >> 
> > Proposed fix has exactly same issue. Until all data is transfered to
> > userspace no interrupt will be served.
> 
> For mmio_fragments that is okay.  It's the same guest instruction, and
> it's still O(1).
> 
> It's not okay for general mmio coalescing.
> 
Ah, so optimizing mmio_fragments transmission to userspace using
dedicated coalesced MMIO buffer should be fine then. Unfortunately,
since we cannot use shared ring buffer that exists now, this is too much
work for small gain that only new QEMU will be able to enjoy.

--
			Gleb.
