Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab0DUV1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 17:27:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755812Ab0DUV1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 17:27:35 -0400
Date: Wed, 21 Apr 2010 14:26:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: linux-kernel@vger.kernel.org, gpxe-devel@etherboot.org,
       Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH 1/2] ibft: Update iBFT handling for v1.03 of the spec.
Message-Id: <20100421142634.ea5ca8a5.akpm@linux-foundation.org>
In-Reply-To: <1270822888-13192-2-git-send-email-konrad@kernel.org>
References: <1270822888-13192-1-git-send-email-konrad@kernel.org>
	<1270822888-13192-2-git-send-email-konrad@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Apr 2010 14:21:27 +0000
Konrad Rzeszutek Wilk <konrad@kernel.org> wrote:

> From: Peter Jones <pjones@redhat.com>
> 
> - Use struct acpi_table_ibft instead of struct ibft_table_header
> - Don't do reserve_ibft_region() on UEFI machines (section 1.4.3.1)
> - If ibft_addr isn't initialized when ibft_init() is called, check for
>   ACPI-based tables.
> 
> Author:      Peter Jones <pjones@redhat.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad@kernel.org>
> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

This should have Peter's Signed-off-by:, please.

>
> ...
>
> +#ifdef CONFIG_ACPI
> +static int __init acpi_find_ibft(struct acpi_table_header *header)
> +{
> +	ibft_addr = (struct acpi_table_ibft *)header;

container_of() would be better here.  And maybe elsewhere, too.

> +	return 0;
> +}
> +#endif /* CONFIG_ACPI */

