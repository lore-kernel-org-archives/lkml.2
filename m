Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab1KJKOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 05:14:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab1KJKOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 05:14:00 -0500
Message-ID: <4EBBA36E.7040705@redhat.com>
Date: Thu, 10 Nov 2011 18:11:58 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Thunderbird/3.1.15
MIME-Version: 1.0
To: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
CC: linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ananth Narayan <ananth@in.ibm.com>, Milton Miller <miltonm@bga.com>,
        Haren Myneni <hbabu@us.ibm.com>, Anton Blanchard <anton@samba.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC PATCH v4 06/10] fadump: Add PT_NOTE program header for vmcoreinfo
References: <20111107095215.1997.14866.stgit@mars.in.ibm.com> <20111107095603.1997.39898.stgit@mars.in.ibm.com>
In-Reply-To: <20111107095603.1997.39898.stgit@mars.in.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年11月07日 17:56, Mahesh J Salgaonkar 写道:
> From: Mahesh Salgaonkar<mahesh@linux.vnet.ibm.com>
>
> Introduce a PT_NOTE program header that points to physical address of
> vmcoreinfo_note buffer declared in kernel/kexec.c. The vmcoreinfo
> note buffer is populated during crash_fadump() at the time of system
> crash.
>
> Signed-off-by: Mahesh Salgaonkar<mahesh@linux.vnet.ibm.com>
> ---
>   arch/powerpc/kernel/fadump.c |   29 +++++++++++++++++++++++++++++
>   1 files changed, 29 insertions(+), 0 deletions(-)
>
> diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
> index 70d6287..e68ee3a 100644
> --- a/arch/powerpc/kernel/fadump.c
> +++ b/arch/powerpc/kernel/fadump.c
> @@ -816,6 +816,19 @@ static void setup_crash_memory_ranges(void)
>   	}
>   }
>
> +/*
> + * If the given physical address falls within the boot memory region then
> + * return the relocated address that points to the dump region reserved
> + * for saving initial boot memory contents.
> + */
> +static inline unsigned long relocate(unsigned long paddr)
> +{
> +	if (paddr>  RMR_START&&  paddr<  fw_dump.boot_memory_size)
> +		return fdm.rmr_region.destination_address + paddr;
> +	else
> +		return paddr;
> +}

Although they are static functions, it is still better to name them
with "fadump_" prefix...

Thanks.
