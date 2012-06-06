Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982Ab2FFVnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:43:15 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:38496 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758835Ab2FFVnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:43:11 -0400
Message-ID: <4FCFCEE5.1000200@xenotime.net>
Date: Wed, 06 Jun 2012 14:43:01 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Dan Williams <dan.j.williams@gmail.com>
Subject: Re: linux-next: Tree for Jun 1 (scsi)
References: <20120601132202.ac73b03c845299d384defeaf@canb.auug.org.au>	 <4FCC2BF9.7000802@xenotime.net> <1338962053.23080.7.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1338962053.23080.7.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2012 10:54 PM, James Bottomley wrote:

> On Sun, 2012-06-03 at 20:31 -0700, Randy Dunlap wrote:
>> On 05/31/2012 08:22 PM, Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20120531:
>>
>>
>>
>> already fixed?
>>
>> on i386 and x86_64, loadable module or builtin:
>>
>>
>> ERROR: "scsi_sd_probe_domain" [drivers/scsi/scsi_mod.ko] undefined!
>> or
>> (.text+0x4f6c77): undefined reference to `scsi_sd_probe_domain'
> 
> This looks to be an obvious thinko:  the symbol is conditionally
> defined, but unconditionally used in
> scsi_scan.c:scsi_complete_async_scans().  We can fix just by removing
> the wrong conditional.
> 
> James
> 
> ---
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 61c82a3..bbbc9c9 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -90,11 +90,9 @@ unsigned int scsi_logging_level;
>  EXPORT_SYMBOL(scsi_logging_level);
>  #endif
>  
> -#if IS_ENABLED(CONFIG_PM) || IS_ENABLED(CONFIG_BLK_DEV_SD)
> -/* sd and scsi_pm need to coordinate flushing async actions */
> +/* sd, scsi core and power management need to coordinate flushing async actions */
>  LIST_HEAD(scsi_sd_probe_domain);
>  EXPORT_SYMBOL(scsi_sd_probe_domain);
>                                 -#endif


Yes, this patch works after I move that "-#endif" to column 1 (or 0).

Thanks.

Acked-by: Randy Dunlap <rdunlap@xenotime.net>


>  

>  /* NB: These are exposed through /proc/scsi/scsi and form part of the ABI.
>   * You may not alter any existing entry (although adding new ones is
> 
> 



-- 
~Randy
