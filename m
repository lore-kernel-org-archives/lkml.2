Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934635Ab2J3VOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 17:14:17 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37952 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934577Ab2J3VOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 17:14:15 -0400
Date: Tue, 30 Oct 2012 17:01:43 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com, fenghua.yu@intel.com,
        len.brown@intel.com, rjw@sisk.pl, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 2/2] ACPI, ia64: export acpi_[un]register_gsi()
Message-ID: <20121030210141.GA21481@phenom.dumpdata.com>
References: <1351502792-13221-1-git-send-email-mika.westerberg@linux.intel.com>
 <1351502792-13221-2-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351502792-13221-2-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 11:26:32AM +0200, Mika Westerberg wrote:
> These functions might be called from modules as well so make sure they are
> exported.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  arch/ia64/kernel/acpi.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
> index 44057885..bd86e39 100644
> --- a/arch/ia64/kernel/acpi.c
> +++ b/arch/ia64/kernel/acpi.c
> @@ -633,6 +633,7 @@ int acpi_register_gsi(struct device *dev, u32 gsi, int triggering, int polarity)
>  				      ACPI_EDGE_SENSITIVE) ? IOSAPIC_EDGE :
>  				     IOSAPIC_LEVEL);
>  }
> +EXPORT_SYMBOL(acpi_register_gsi);

_GPL ?
>  
>  void acpi_unregister_gsi(u32 gsi)
>  {
> @@ -644,6 +645,7 @@ void acpi_unregister_gsi(u32 gsi)
>  
>  	iosapic_unregister_intr(gsi);
>  }
> +EXPORT_SYMBOL(acpi_unregister_gsi);
>  
>  static int __init acpi_parse_fadt(struct acpi_table_header *table)
>  {
> -- 
> 1.7.12.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
