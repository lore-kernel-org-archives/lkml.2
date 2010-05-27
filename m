Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903Ab0E0RmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:42:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60633 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932611Ab0E0RmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:42:10 -0400
Date: Thu, 27 May 2010 10:41:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       zamsden@redhat.com
Subject: Re: [PATCH v3] Add Documentation/kvm/msr.txt
Message-Id: <20100527104123.5f937adc.randy.dunlap@oracle.com>
In-Reply-To: <1274978028-9827-1-git-send-email-glommer@redhat.com>
References: <1274978028-9827-1-git-send-email-glommer@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4BFEAEE8.00D6:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010 12:33:48 -0400 Glauber Costa wrote:

> This patch adds a file that documents the usage of KVM-specific
> MSRs.
> 
> [ v2: added comments from Randy ]
> [ v2: added comments from Avi ]
> 
> Signed-off-by: Glauber Costa <glommer@redhat.com>

Reviewed-by: Randy Dunlap <randy.dunlap@oracle.com>


> ---
>  Documentation/kvm/msr.txt |  152 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 152 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/kvm/msr.txt
> 
> diff --git a/Documentation/kvm/msr.txt b/Documentation/kvm/msr.txt
> new file mode 100644
> index 0000000..8cdcb6d
> --- /dev/null
> +++ b/Documentation/kvm/msr.txt
> @@ -0,0 +1,152 @@
> +KVM-specific MSRs.
> +Glauber Costa <glommer@redhat.com>, Red Hat Inc, 2010
> +=====================================================
> +
> +KVM makes use of some custom MSRs to service some requests.
> +At present, this facility is only used by kvmclock.
> +
> +Custom MSRs have a range reserved for them, that goes from
> +0x4b564d00 to 0x4b564dff. There are MSRs outside this area,
> +but they are deprecated and their use is discouraged.
> +
> +Custom MSR list
> +--------
> +
> +The current supported Custom MSR list is:
> +
> +MSR_KVM_WALL_CLOCK_NEW:   0x4b564d00
> +
> +	data: physical address of a memory area which must be in guest RAM.
> +	This memory is expected to hold a copy of the following structure:
> +
> +	struct pvclock_wall_clock {
> +		u32   version;
> +		u32   sec;
> +		u32   nsec;
> +	} __attribute__((__packed__));
> +
> +	whose data will be filled in by the hypervisor. The hypervisor is only 
> +	guaranteed to update this data at the moment of MSR write.
> +	Users that want to reliably query this information more than once have

	Users who want

> +	to write more than once to this MSR. Fields have the following meanings:
> +
> +		version: guest has to check version before and after grabbing
> +		time information and check that they are both equal and even.
> +		An odd version indicates an in-progress update.
> +
> +		sec: number of seconds for wallclock.
> +
> +		nsec: number of nanoseconds for wallclock.


Thanks.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
