Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323Ab1CWECA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 00:02:00 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:53242 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab1CWEB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 00:01:58 -0400
Date: Wed, 23 Mar 2011 00:01:50 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 4/4] ACPI: Make sure the FADT is at least rev 2 before
 using the reset register
In-reply-to: <1299877940-6870-4-git-send-email-mjg@redhat.com>
Message-id: <alpine.LFD.2.02.1103222354150.10549@x980>
References: <1299877940-6870-1-git-send-email-mjg@redhat.com>
 <1299877940-6870-4-git-send-email-mjg@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 11 Mar 2011, Matthew Garrett wrote:

> The reset register was only introduced with version 2 of the FADT, so we
> should check that the FADT revision before trusting its contents.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  drivers/acpi/reboot.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/reboot.c b/drivers/acpi/reboot.c
> index 4870aaa..a6c77e8b 100644
> --- a/drivers/acpi/reboot.c
> +++ b/drivers/acpi/reboot.c
> @@ -15,6 +15,11 @@ void acpi_reboot(void)
>  
>  	rr = &acpi_gbl_FADT.reset_register;
>  
> +	/* ACPI reset register was only introduced with v2 of the FADT */
> +
> +	if (acpi_gbl_FADT.header.revision < 2)
> +		return;
> +

Isn't this check redundant with the check just below this hunk?

>  	/* Is the reset register supported? The spec says we should be
>  	 * checking the bit width and bit offset, but Windows ignores
>  	 * these fields */


        if (!(acpi_gbl_FADT.flags & ACPI_FADT_RESET_REGISTER))
                return;

For it not to be redundant, there would have to be FADTs out there
of revision 1 that set what was then a reserved bit in the flags.

thanks,
Len Brown, Intel Open Source Technology Center

