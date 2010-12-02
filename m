Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466Ab0LBXn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 18:43:56 -0500
Received: from adelie.canonical.com ([91.189.90.139]:35774 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758441Ab0LBXny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 18:43:54 -0500
Message-ID: <4CF82F2D.8040705@canonical.com>
Date: Fri, 03 Dec 2010 07:43:41 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 3/3] ideapad: add hotkey support
References: <1289977165-14802-1-git-send-email-ike.pan@canonical.com>	 <1289977238-15113-1-git-send-email-ike.pan@canonical.com> <1291333287.10586.4698.camel@nimitz>
In-Reply-To: <1291333287.10586.4698.camel@nimitz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2010 07:41 AM, Dave Hansen wrote:
> On Wed, 2010-11-17 at 15:00 +0800, Ike Panhc wrote:
>> +static void ideapad_input_report(unsigned long scancode)
>> +{
>> +       sparse_keymap_report_event(ideapad_priv->inputdev, scancode, 1, true);
>> +} 
> 
> I got a little build error about some unresolved symbols in the module
> while compiling:
>         
>         ERROR: "sparse_keymap_setup" [drivers/platform/x86/ideapad-laptop.ko] undefined!
>         ERROR: "sparse_keymap_free" [drivers/platform/x86/ideapad-laptop.ko] undefined!
>         ERROR: "sparse_keymap_report_event" [drivers/platform/x86/ideapad-laptop.ko] undefined!
>         
> You can get it to go away by setting CONFIG_INPUT_SPARSEKMAP=m or =y
> in .config.  But, I think your patches need this:
> 
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index faec777..879d266 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -226,6 +226,7 @@ config IDEAPAD_LAPTOP
>  	tristate "Lenovo IdeaPad Laptop Extras"
>  	depends on ACPI
>  	depends on RFKILL
> +	select INPUT_SPARSEKMAP
>  	help
>  	  This is a driver for the rfkill switches on Lenovo IdeaPad netbooks.
>  
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> 

Thanks, you are right
