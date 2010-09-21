Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab0IUMjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 08:39:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42701 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab0IUMju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 08:39:50 -0400
Date: Tue, 21 Sep 2010 14:39:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, linux-acpi@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 1/5] ACPI, APEI, Fix APEI related table size checking
Message-ID: <20100921123945.GB18991@one.firstfloor.org>
References: <1284865235-29920-1-git-send-email-ying.huang@intel.com> <1284865235-29920-2-git-send-email-ying.huang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284865235-29920-2-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 19, 2010 at 11:00:31AM +0800, Huang Ying wrote:
> From: Yinghai Lu <yinghai@kernel.org>
> 
> Both ERST and EINJ table size checking is fixed.

Needs a better description.
> ---
>  drivers/acpi/apei/einj.c |    3 ++-
>  drivers/acpi/apei/erst.c |    3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
> index 465c885..b184baa 100644
> --- a/drivers/acpi/apei/einj.c
> +++ b/drivers/acpi/apei/einj.c
> @@ -426,7 +426,8 @@ DEFINE_SIMPLE_ATTRIBUTE(error_inject_fops, NULL,
>  
>  static int einj_check_table(struct acpi_table_einj *einj_tab)
>  {
> -	if (einj_tab->header_length != sizeof(struct acpi_table_einj))
> +	if (einj_tab->header_length !=
> +	    (sizeof(struct acpi_table_einj) - sizeof(einj_tab->header)))

I don't understand these changes. So on any system where the old check worked
before it won't work anymore?  Since the code has been presumably tested
before this would break systems, won't it?

Same with the other changes.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
