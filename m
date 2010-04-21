Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab0DUVbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 17:31:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756193Ab0DUVbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 17:31:12 -0400
Date: Wed, 21 Apr 2010 14:29:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: linux-kernel@vger.kernel.org, gpxe-devel@etherboot.org,
       Mike Christie <michaelc@cs.wisc.edu>, Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH 2/2] ibft: For UEFI machines actually do scan ACPI for
 iBFT.
Message-Id: <20100421142928.9699de85.akpm@linux-foundation.org>
In-Reply-To: <1270822888-13192-3-git-send-email-konrad@kernel.org>
References: <1270822888-13192-1-git-send-email-konrad@kernel.org>
	<1270822888-13192-3-git-send-email-konrad@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Apr 2010 14:21:28 +0000
Konrad Rzeszutek Wilk <konrad@kernel.org> wrote:

> For machines with IBFT 1.03 do scan the ACPI table for 'iBFT'
> or for 'IBFT'. If the machine is in UEFI mode, only do the ACPI
> table scan. For all other machines (pre IBFT 1.03) do
> a memory scan if not found in the ACPI tables.
> 
> Author: Konrad Rzeszutek Wilk <konrad@kernel.org>

The Author: line is unneeded and inappropriate here.  That's what the
From: line does.

> Acked-by: Peter Jones <pjones@redhat.com>
> Tested-by: Mike Christie <michaelc@cs.wisc.edu>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad@kernel.org>

Your covering email indicates that Mike and Peter wrote the patches,
but neither of the patches have their signoffs.  Can we please sort all
this out?


> ---
>  drivers/firmware/iscsi_ibft_find.c |   31 +++++++++++++++++++------------
>  1 files changed, 19 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/firmware/iscsi_ibft_find.c b/drivers/firmware/iscsi_ibft_find.c
> index 8f4d157..0bc3fae 100644
> --- a/drivers/firmware/iscsi_ibft_find.c
> +++ b/drivers/firmware/iscsi_ibft_find.c
> @@ -56,23 +56,12 @@ static int __init acpi_find_ibft(struct acpi_table_header *header)
>  }
>  #endif /* CONFIG_ACPI */
>  
> -/*
> - * Routine used to find the iSCSI Boot Format Table. The logical
> - * kernel address is set in the ibft_addr global variable.
> - */
> -unsigned long __init find_ibft_region(unsigned long *sizep)
> +static int __init find_ibft_mem_scan(void)

The name seems weird.  find_foo_scan().  So we're trying to find a scan
for a foo.

>  {
>  	unsigned long pos;
>  	unsigned int len = 0;
>  	void *virt;
>  
> -	ibft_addr = NULL;
> -
> -	/* iBFT 1.03 section 1.4.3.1 mandates that UEFI machines will
> -	 * only use ACPI for this */
> -	if (efi_enabled)
> -		return 0;
> -
>  	for (pos = IBFT_START; pos < IBFT_END; pos += 16) {
>  		/* The table can't be inside the VGA BIOS reserved space,
>  		 * so skip that area */
>
> ...
>
