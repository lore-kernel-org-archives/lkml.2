Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab1GXRgS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 13:36:18 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:49126 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751512Ab1GXRgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 13:36:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=BG0CXDQzt72NAMc1L5cQsl2UKk5gTPThljWi+PlCWvkHRn1FubYxqO3+cpSusn1ahO4jSJrOZJI67fVddXfRPSBmvlw+jyQ+IzfZbCK4yAuV67jqPIIwfnhEYiWTKDBA;
Date: Sun, 24 Jul 2011 10:36:10 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Daniel Drake <dsd@laptop.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, dilinger@queued.net
Subject: Re: [PATCH] x86, olpc: Fix dependency on POWER_SUPPLY
Message-Id: <20110724103610.0a7f6ecf.rdunlap@xenotime.net>
In-Reply-To: <20110724173321.747BC9D401C@zog.reactivated.net>
References: <20110724173321.747BC9D401C@zog.reactivated.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jul 2011 18:33:21 +0100 (BST) Daniel Drake wrote:

> As reported by Randy Dunlap, CONFIG_POWER_SUPPLY=m caused a compile error:
> 
> arch/x86/built-in.o: In function `battery_status_changed':
> olpc-xo15-sci.c:(.text+0x3acdd): undefined reference to `power_supply_get_by_name'
> olpc-xo15-sci.c:(.text+0x3ad04): undefined reference to `power_supply_changed'
> 
> The SCI drivers, as bool, require POWER_SUPPLY to be builtin. Use
> select to make that a hard requirement and avoid this build failure.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  arch/x86/Kconfig |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 8af5ba8..b198c01 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -2089,7 +2089,8 @@ config OLPC_XO1_RTC
>  
>  config OLPC_XO1_SCI
>  	bool "OLPC XO-1 SCI extras"
> -	depends on OLPC && OLPC_XO1_PM && POWER_SUPPLY
> +	depends on OLPC && OLPC_XO1_PM
> +	select POWER_SUPPLY
>  	select GPIO_CS5535
>  	select MFD_CORE
>  	---help---
> @@ -2103,7 +2104,8 @@ config OLPC_XO1_SCI
>  
>  config OLPC_XO15_SCI
>  	bool "OLPC XO-1.5 SCI extras"
> -	depends on OLPC && ACPI && POWER_SUPPLY
> +	depends on OLPC && ACPI
> +	select POWER_SUPPLY
>  	---help---
>  	  Add support for SCI-based features of the OLPC XO-1.5 laptop:
>  	   - EC-driven system wakeups
> -- 
> 1.7.6
> 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
