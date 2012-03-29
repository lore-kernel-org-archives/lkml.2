Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933500Ab2C2P2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 11:28:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484Ab2C2P2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 11:28:46 -0400
Message-ID: <4F747F91.20005@redhat.com>
Date: Thu, 29 Mar 2012 17:28:17 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 05/13] KVM: MMU: reset shadow_mmio_mask
References: <4F742951.7080003@linux.vnet.ibm.com> <4F742A06.8090604@linux.vnet.ibm.com> <4F745F28.2040105@redhat.com>
In-Reply-To: <4F745F28.2040105@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 03:10 PM, Avi Kivity wrote:
> On 03/29/2012 11:23 AM, Xiao Guangrong wrote:
> > Do not use the last byte (bit 56 ~ bit 63) in shadow_mmio_mask, the late
> > patch will store vcpu id in the last byte
>
> Bit 63 is PT64_NX_MASK.

Oh, you did say that with softmmu we're limited to 127 cpus.  But what
if spte.nx is changed while we update the identity?

-- 
error compiling committee.c: too many arguments to function

