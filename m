Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab2L0EDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 23:03:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52388 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743Ab2L0EDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 23:03:09 -0500
Message-ID: <50DBC856.6030208@zytor.com>
Date: Wed, 26 Dec 2012 20:02:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Daniel Kiper <daniel.kiper@oracle.com>
CC: andrew.cooper3@citrix.com, ebiederm@xmission.com, jbeulich@suse.com,
        konrad.wilk@oracle.com, maxim.uvarov@oracle.com, mingo@redhat.com,
        tglx@linutronix.de, vgoyal@redhat.com, x86@kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH v3 00/11] xen: Initial kexec/kdump implementation
References: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com>
In-Reply-To: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2012 06:18 PM, Daniel Kiper wrote:
> Hi,
>
> This set of patches contains initial kexec/kdump implementation for Xen v3.
> Currently only dom0 is supported, however, almost all infrustructure
> required for domU support is ready.
>
> Jan Beulich suggested to merge Xen x86 assembler code with baremetal x86 code.
> This could simplify and reduce a bit size of kernel code. However, this solution
> requires some changes in baremetal x86 code. First of all code which establishes
> transition page table should be moved back from machine_kexec_$(BITS).c to
> relocate_kernel_$(BITS).S. Another important thing which should be changed in that
> case is format of page_list array. Xen kexec hypercall requires to alternate physical
> addresses with virtual ones. These and other required stuff have not been done in that
> version because I am not sure that solution will be accepted by kexec/kdump maintainers.
> I hope that this email spark discussion about that topic.
>

I want a detailed list of the constraints that this assumes and 
therefore imposes on the native implementation as a result of this.  We 
have had way too many patches where Xen PV hacks effectively nailgun 
arbitrary, and sometimes poor, design decisions in place and now we 
can't fix them.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

