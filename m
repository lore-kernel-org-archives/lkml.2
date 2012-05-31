Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab2EaRpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 13:45:07 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:49300 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757094Ab2EaRpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 13:45:00 -0400
Message-ID: <4FC7AE15.9040807@xenotime.net>
Date: Thu, 31 May 2012 10:44:53 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Alexander Graf <agraf@suse.de>, KVM <kvm@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH] Documentation/kvm : Add documentation on Hypercalls
References: <20120531080116.24838.15692.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20120531080116.24838.15692.sendpatchset@codeblue.in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2012 01:01 AM, Raghavendra K T wrote:

> From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> 
> 
> Thanks Alex for KVM_HC_FEATURES inputs and Jan for VAPIC_POLL_IRQ 
> 
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
> diff --git a/Documentation/virtual/kvm/hypercalls.txt b/Documentation/virtual/kvm/hypercalls.txt
> new file mode 100644
> index 0000000..c79335a
> --- /dev/null
> +++ b/Documentation/virtual/kvm/hypercalls.txt
> @@ -0,0 +1,46 @@
> +KVM Hypercalls Documentation
> +===========================
> +The template for each hypercall is:
> +1. Hypercall name, value.
> +2. Architecture(s)
> +3. Status (deprecated, obsolete, active)
> +4. Purpose
> +
> +1. KVM_HC_VAPIC_POLL_IRQ
> +------------------------
> +Value: 1
> +Architecture: x86


No "Status", does that imply "Active" ?

> +Purpose: Trigger guest exit so that the host can check for pending
> +interrupts on reentry.
> +
> +2. KVM_HC_MMU_OP
> +------------------------
> +Value: 2
> +Architecture: x86
> +Status: deprecated.
> +Purpose: Support MMU operations such as writing to PTE,
> +flushing TLB, release PT.
> +
> +3. KVM_HC_FEATURES
> +------------------------
> +Value: 3
> +Architecture: PPC
> +Status: active
> +Purpose: Expose hypercall availability to the guest. On x86 platforms, cpuid
> +used to enumerate which hypercalls are available. On PPC, either device tree
> +based lookup ( which is also what EPAPR dictates) OR KVM specific enumeration
> +mechanism (which is this hypercall) can be used.
> +
> +4. KVM_HC_PPC_MAP_MAGIC_PAGE
> +------------------------
> +Value: 4
> +Architecture: PPC
> +Status: active
> +Purpose: To enable communication between the hypervisor and guest there is a
> +shared page that contains parts of supervisor visible register state.
> +The guest can map this shared page to access its supervisor register through
> +memory using this hypercall.
> +
> +TODO:
> +1. more information on input and output needed?
> +2. Add more detail to purpose of hypercalls.
> 
> --


-- 
~Randy
