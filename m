Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab1IAQrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 12:47:04 -0400
Received: from claw.goop.org ([74.207.240.146]:42176 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab1IAQrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 12:47:02 -0400
Message-ID: <4E5FB700.1070908@goop.org>
Date: Thu, 01 Sep 2011 09:46:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Igor Mammedov <imammedo@redhat.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com
Subject: Re: [PATCH v2] xen: x86_32: do not enable iterrupts when returning
 from exception in interrupt context
References: <4E5EB794.7050909@goop.org> <1314877615-18280-1-git-send-email-imammedo@redhat.com>
In-Reply-To: <1314877615-18280-1-git-send-email-imammedo@redhat.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2011 04:46 AM, Igor Mammedov wrote:
> If vmalloc page_fault happens inside of interrupt handler with interrupts
> disabled then on exit path from exception handler when there is no pending
> interrupts, the following code (arch/x86/xen/xen-asm_32.S:112):
>
> 	cmpw $0x0001, XEN_vcpu_info_pending(%eax)
> 	sete XEN_vcpu_info_mask(%eax)
>
> will enable interrupts even if they has been previously disabled according to
> eflags from the bounce frame (arch/x86/xen/xen-asm_32.S:99)
>
> 	testb $X86_EFLAGS_IF>>8, 8+1+ESP_OFFSET(%esp)
> 	setz XEN_vcpu_info_mask(%eax)
>
> Solution is in setting XEN_vcpu_info_mask only when it should be set
> according to
> 	cmpw $0x0001, XEN_vcpu_info_pending(%eax)
> but not clearing it if there isn't any pending events.
>
> Reproducer for bug is attached to RHBZ 707552
>
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>

One nit, this should be acked-by or reviewed-by, not signed-off-by,
since the patch isn't passing through my hands.

    J
