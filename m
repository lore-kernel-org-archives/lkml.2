Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab0DMXPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 19:15:53 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53762 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab0DMXPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 19:15:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=OxqGx8fe1aCfkF590l2298wzbr1njs1/zRRKyGMAcLVDgtQqS4ARaz5yUwA6os9uri
         2z78VdfYtv0VCwAOWajmPBI8t/MzEd6NCnH9mVU2uMRn0rOlLc86uLpigu3p7FGV7kWm
         mx27/k8Ao2/DtdAwxTk84WX4nyTSO6+stXTF4=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH -next] eeepc-wmi: depends on INPUT_SPARSEKMAP
Date: Tue, 13 Apr 2010 15:39:34 -0700
User-Agent: KMail/1.13.1 (Linux/2.6.34-rc4; KDE/4.4.1; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Matthew Garrett <mjg@redhat.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       platform-driver-x86@vger.kernel.org
References: <20100413163427.8acd04e5.sfr@canb.auug.org.au> <20100413094544.38369da9.randy.dunlap@oracle.com>
In-Reply-To: <20100413094544.38369da9.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004131539.34998.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 April 2010 09:45:44 am Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> When EEEPC_WMI=y and INPUT_SPARSEKMAP=m, the build fails,
> so make EEEPC_WMI depend on INPUT_SPARSEKMAP.
> 
> eeepc-wmi.c:(.text+0x28d1a9): undefined reference to `sparse_keymap_setup'
> eeepc-wmi.c:(.text+0x28d1f9): undefined reference to `sparse_keymap_free'
> eeepc-wmi.c:(.text+0x28d2e0): undefined reference to
> `sparse_keymap_report_event' eeepc-wmi.c:(.init.text+0x17069): undefined
> reference to `sparse_keymap_free' eeepc-wmi.c:(.exit.text+0x2bae):
> undefined reference to `sparse_keymap_free'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/platform/x86/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20100413.orig/drivers/platform/x86/Kconfig
> +++ linux-next-20100413/drivers/platform/x86/Kconfig
> @@ -388,7 +388,7 @@ config EEEPC_LAPTOP
>  config EEEPC_WMI
>  	tristate "Eee PC WMI Hotkey Driver (EXPERIMENTAL)"
>  	depends on ACPI_WMI
> -	depends on INPUT
> +	depends on INPUT && INPUT_SPARSEKMAP

"select INPUT_SPARSEKMAP" please - users should not be concerned about
such implementation details.

-- 
Dmitry
