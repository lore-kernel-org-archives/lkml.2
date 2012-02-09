Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab2BIQnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 11:43:22 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:65013 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758089Ab2BIQnU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 11:43:20 -0500
MIME-Version: 1.0
In-Reply-To: <20120209163641.26858.59399.stgit@amt.stowe>
References: <20120209163641.26858.59399.stgit@amt.stowe>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 9 Feb 2012 08:42:59 -0800
Message-ID: <CAErSpo47+kHmS6477Bne84rPiy+sHGjgtK3mpk6VJc+hM4hhbg@mail.gmail.com>
Subject: Re: [PATCH] ACPI: Fix logic for removing mappings in 'acpi_unmap'
To: Myron Stowe <myron.stowe@redhat.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, ying.huang@intel.com,
        tony.luck@intel.com, trenn@suse.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 9, 2012 at 8:36 AM, Myron Stowe <myron.stowe@redhat.com> wrote:
> From: Myron Stowe <mstowe@redhat.com>
>
> Make sure the removal of mappings uses the same logic that put the
> mappings in place.
>
> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
> ---
>
>  drivers/acpi/osl.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 412a1e0..5aef087 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -347,7 +347,7 @@ static void acpi_unmap(acpi_physical_address pg_off, void __iomem *vaddr)
>        unsigned long pfn;
>
>        pfn = pg_off >> PAGE_SHIFT;
> -       if (page_is_ram(pfn))
> +       if (should_use_kmap(pfn))
>                kunmap(pfn_to_page(pfn));
>        else
>                iounmap(vaddr);
>

Whatever happened to the question of why we have arch-specific
ioremap() behavior?  It's good to make map/unmap symmetric, but it'd
be better to get rid of the ioremap/kmap hack.

Bjorn
