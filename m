Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360Ab0LMAQW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:16:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:23982 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850Ab0LMAQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 19:16:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,333,1288594800"; 
   d="scan'208";a="635640690"
Subject: Re: [PATCH] ACPI: Make sure the FADT is at least rev 2 before
 using the reset register
From: Zhang Rui <rui.zhang@intel.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1292003871-13979-1-git-send-email-mjg@redhat.com>
References: <1292003871-13979-1-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Dec 2010 08:16:36 +0800
Message-ID: <1292199396.1715.143.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-12-11 at 01:57 +0800, Matthew Garrett wrote:
> The reset register was only introduced with version 2 of the FADT, so we
> should check that the FADT revision before trusting its contents.
> 
does the current code break anything?
I'm curious about how you found this bug. :)

thanks,
rui

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
>  	/* Is the reset register supported? The spec says we should be
>  	 * checking the bit width and bit offset, but Windows ignores
>  	 * these fields */


