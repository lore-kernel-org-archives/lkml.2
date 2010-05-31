Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab0EaLDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 07:03:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab0EaLDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 07:03:22 -0400
Message-ID: <4C03974A.8050802@redhat.com>
Date: Mon, 31 May 2010 14:02:34 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, masbock@linux.vnet.ibm.com,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH -v3] KVM, Fix QEMU-KVM is killed by guest SRAO MCE (resend)
References: <1275287299.3444.423.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1275287299.3444.423.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2010 09:28 AM, Huang Ying wrote:
> In common cases, guest SRAO MCE will cause corresponding poisoned page
> be un-mapped and SIGBUS be sent to QEMU-KVM, then QEMU-KVM will relay
> the MCE to guest OS.
>
> But it is reported that if the poisoned page is accessed in guest
> after un-mapped and before MCE is relayed to guest OS, QEMU-KVM will
> be killed.
>
> The reason is as follow. Because poisoned page has been un-mapped,
> guest access will cause guest exit and kvm_mmu_page_fault will be
> called. kvm_mmu_page_fault can not get the poisoned page for fault
> address, so kernel and user space MMIO processing is tried in turn. In
> user MMIO processing, poisoned page is accessed again, then QEMU-KVM
> is killed by force_sig_info.
>
> To fix the bug, kvm_mmu_page_fault send HWPOISON signal to QEMU-KVM
> and do not try kernel and user space MMIO processing for poisoned
> page.
>    

Applied, thanks.  Sorry about the delay.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

