Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab1IBNky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 09:40:54 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:60883 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab1IBNkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 09:40:53 -0400
Date: Fri, 2 Sep 2011 09:40:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: [PATCH v2] xen: x86_32: do not enable iterrupts
 when returning from exception in interrupt context
Message-ID: <20110902134032.GA6064@dumpdata.com>
References: <4E5EB794.7050909@goop.org>
 <1314877615-18280-1-git-send-email-imammedo@redhat.com>
 <4E5FB700.1070908@goop.org>
 <4E60914F.7080208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E60914F.7080208@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090204.4E60DCDC.0005,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 10:18:23AM +0200, Igor Mammedov wrote:
> On 09/01/2011 06:46 PM, Jeremy Fitzhardinge wrote:
> >On 09/01/2011 04:46 AM, Igor Mammedov wrote:
> >>If vmalloc page_fault happens inside of interrupt handler with interrupts
> >>disabled then on exit path from exception handler when there is no pending
> >>interrupts, the following code (arch/x86/xen/xen-asm_32.S:112):
> >>
> >>	cmpw $0x0001, XEN_vcpu_info_pending(%eax)
> >>	sete XEN_vcpu_info_mask(%eax)
> >>
> >>will enable interrupts even if they has been previously disabled according to
> >>eflags from the bounce frame (arch/x86/xen/xen-asm_32.S:99)
> >>
> >>	testb $X86_EFLAGS_IF>>8, 8+1+ESP_OFFSET(%esp)
> >>	setz XEN_vcpu_info_mask(%eax)
> >>
> >>Solution is in setting XEN_vcpu_info_mask only when it should be set
> >>according to
> >>	cmpw $0x0001, XEN_vcpu_info_pending(%eax)
> >>but not clearing it if there isn't any pending events.
> >>
> >>Reproducer for bug is attached to RHBZ 707552
> >>
> >>Signed-off-by: Igor Mammedov<imammedo@redhat.com>
> >>Signed-off-by: Jeremy Fitzhardinge<jeremy@goop.org>
> >
> >One nit, this should be acked-by or reviewed-by, not signed-off-by,
> >since the patch isn't passing through my hands.
> >
> >     J
> 
> I'm new to this stuff, would you like me to re-post it?

That is OK.  I fixed it up in the git commit. Thanks for finding this one!
