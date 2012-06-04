Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760694Ab2FDOmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 10:42:14 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:58937 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760432Ab2FDOmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 10:42:08 -0400
Message-ID: <4FCCC938.7080900@xenotime.net>
Date: Mon, 04 Jun 2012 07:42:00 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH -next] acpi: fix acpi_bus.h warnings when ACPI is not
 enabled
References: <20120523170740.ae058d8d5468d471eb948c39@canb.auug.org.au> <4FBD0CDD.6010003@xenotime.net> <4FCC3A4C.2080407@kernel.org>
In-Reply-To: <4FCC3A4C.2080407@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2012 09:32 PM, Len Brown wrote:

> Hi Randy,
> with your patch applied and CONFIG_ACPI=n, I still get:
> 
> include/acpi/acpi_bus.h:445:12: warning: ‘register_acpi_bus_type’ defined but not used [-Wunused-function]
> include/acpi/acpi_bus.h:446:12: warning: ‘unregister_acpi_bus_type’ defined but not used [-Wunused-function]
> 
> so I think I prefer the patch below.

Hi Len,

I'd love to see your failing .config file if you have it or can
reproduce it.  My patch still works for me.


> thanks,
> Len Brown, Intel Open Source Technology Center
> 
> On 05/23/2012 12:14 PM, Randy Dunlap wrote:
> 
>> From: Randy Dunlap <rdunlap@xenotime.net>
>>
>> Fix header file warnings when CONFIG_ACPI is not enabled:
>>
>> include/acpi/acpi_bus.h:443:42: warning: 'struct acpi_bus_type' declared inside parameter list
>> include/acpi/acpi_bus.h:443:42: warning: its scope is only this definition or declaration, which is probably not what you want
>> include/acpi/acpi_bus.h:444:44: warning: 'struct acpi_bus_type' declared inside parameter list
>>
>> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
>> ---
>>  include/acpi/acpi_bus.h |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> --- linux-next-20120523.orig/include/acpi/acpi_bus.h
>> +++ linux-next-20120523/include/acpi/acpi_bus.h
>> @@ -440,6 +440,8 @@ static inline int acpi_pm_device_sleep_w
>>  
>>  #else	/* CONFIG_ACPI */
>>  
>> +struct acpi_bus_type;
>> +
>>  static int register_acpi_bus_type(struct acpi_bus_type *bus) { return 0; }
>>  static int unregister_acpi_bus_type(struct acpi_bus_type *bus) { return 0; }
>>  
> 
> 
> Subject: [PATCH] ACPI: fix acpi_bus.h build warnings when ACPI is not enabled
> 
> introduced in Linux-3.5-rc1 by
> 66886d6f8c9bcdee3d7fce5796dcffd6b4bc0b48
> (ACPI: Add stubs for (un)register_acpi_bus_type)
> 
> Fix header file warnings when CONFIG_ACPI is not enabled:
> 
> include/acpi/acpi_bus.h:443:42: warning: 'struct acpi_bus_type' declared inside parameter list
> include/acpi/acpi_bus.h:443:42: warning: its scope is only this definition or declaration, which is probably not
> include/acpi/acpi_bus.h:444:44: warning: 'struct acpi_bus_type' declared inside parameter list
> 
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  include/acpi/acpi_bus.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> index b0d6282..9e6e1c6 100644
> --- a/include/acpi/acpi_bus.h
> +++ b/include/acpi/acpi_bus.h
> @@ -440,8 +440,8 @@ static inline int acpi_pm_device_sleep_wake(struct device *dev, bool enable)
>  
>  #else	/* CONFIG_ACPI */
>  
> -static int register_acpi_bus_type(struct acpi_bus_type *bus) { return 0; }
> -static int unregister_acpi_bus_type(struct acpi_bus_type *bus) { return 0; }
> +static inline int register_acpi_bus_type(void *bus) { return 0; }
> +static inline int unregister_acpi_bus_type(void *bus) { return 0; }
>  
>  #endif				/* CONFIG_ACPI */
>  



-- 
~Randy
