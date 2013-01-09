Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab3AIA2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 19:28:34 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:35244 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851Ab3AIA2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 19:28:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: SRAT: report non-volatile memory in debug
Date: Wed, 09 Jan 2013 01:34:14 +0100
Message-ID: <1692605.TGpS6mF86Q@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc2+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1357690556.1890.13.camel@buesod1.americas.hpqcorp.net>
References: <1357690556.1890.13.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 08, 2013 04:15:56 PM Davidlohr Bueso wrote:
> Just as with the other memory affinity flags, report
> non-volatile memory with ACPI debug.

Looks kind of good, but ->

> Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
> ---
>  drivers/acpi/numa.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
> index cb31298..68077ac 100644
> --- a/drivers/acpi/numa.c
> +++ b/drivers/acpi/numa.c
> @@ -116,12 +116,14 @@ acpi_table_print_srat_entry(struct acpi_subtable_header *header)
>  			struct acpi_srat_mem_affinity *p =
>  			    (struct acpi_srat_mem_affinity *)header;
>  			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> -					  "SRAT Memory (0x%lx length 0x%lx) in proximity domain %d %s%s\n",
> +					  "SRAT Memory (0x%lx length 0x%lx) in proximity domain %d %s%s%s\n",
>  					  (unsigned long)p->base_address,
>  					  (unsigned long)p->length,
>  					  p->proximity_domain,
>  					  (p->flags & ACPI_SRAT_MEM_ENABLED)?
>  					  "enabled" : "disabled",
> +					  (p->flags & ACPI_SRAT_MEM_NON_VOLATILE)?
> +					  " non-volatile" : "",

-> why did you put non-volatile before hot-pluggable?

>  					  (p->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE)?
>  					  " hot-pluggable" : ""));
>  		}

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
