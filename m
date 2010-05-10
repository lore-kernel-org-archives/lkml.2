Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab0EJRCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 13:02:21 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17247 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab0EJRCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 13:02:13 -0400
Message-ID: <4BE83BC4.90504@oracle.com>
Date: Mon, 10 May 2010 10:00:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Len Brown <lenb@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [BUGFIX] ACPI, APEI, Fix building of APEI EINJ and GHES
References: <1273483482.3344.65.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1273483482.3344.65.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090203.4BE83BCE.001F:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/10 02:24, Huang Ying wrote:
> Randy reported building warnings and errors for APEI EINJ and GHES as follow:
> 
> drivers/acpi/apei/einj.c:127:error: implicit declaration of function 'ndelay'
> 
> ghes.c:(.text+0x119e71): undefined reference to `apei_mce_report_mem_error'
> CONFIG_X86_MCE is not enabled
> 
> This patch fixes these two bugs.
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Yes, fixed.  Thanks.

> ---
>  drivers/acpi/apei/einj.c |    1 +
>  drivers/acpi/apei/ghes.c |    2 ++
>  2 files changed, 3 insertions(+)
> 
> --- a/drivers/acpi/apei/einj.c
> +++ b/drivers/acpi/apei/einj.c
> @@ -29,6 +29,7 @@
>  #include <linux/init.h>
>  #include <linux/io.h>
>  #include <linux/debugfs.h>
> +#include <linux/delay.h>
>  #include <linux/seq_file.h>
>  #include <linux/nmi.h>
>  #include <acpi/acpi.h>
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -242,6 +242,7 @@ static void ghes_do_proc(struct ghes *gh
>  
>  	ser = ghes_severity(ghes->estatus->error_severity);
>  	apei_estatus_for_each_section(ghes->estatus, gdata) {
> +#ifdef CONFIG_X86_MCE
>  		if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
>  				 CPER_SEC_PLATFORM_MEM)) {
>  			apei_mce_report_mem_error(
> @@ -249,6 +250,7 @@ static void ghes_do_proc(struct ghes *gh
>  				(struct cper_sec_mem_err *)(gdata+1));
>  			processed = 1;
>  		}
> +#endif
>  	}
>  
>  	if (!processed && printk_ratelimit())
> 
> 


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
