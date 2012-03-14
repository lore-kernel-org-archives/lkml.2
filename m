Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab2CNAnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 20:43:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42252 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759826Ab2CNAns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 20:43:48 -0400
Message-ID: <4F5FE9AD.7000204@zytor.com>
Date: Tue, 13 Mar 2012 17:43:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Michal Januszewski <spock@gentoo.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: export 'pcibios_enabled'
References: <20120313204114.e160849af7dbe5a4b4e5c0ad@canb.auug.org.au> <4F5FAE63.3090908@xenotime.net>
In-Reply-To: <4F5FAE63.3090908@xenotime.net>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2012 01:30 PM, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Export 'pcibios_enabled' so that when uvesafb is built as a
> loadable module (on X86_32), the build will succeed.
> 
> ERROR: "pcibios_enabled" [drivers/video/uvesafb.ko] undefined!
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc:	Michal Januszewski <spock@gentoo.org>
> Cc:	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> Cc:	linux-fbdev@vger.kernel.org
> Cc:	x86@kernel.org
> ---
> Applies to mainline; found in linux-next.
> 
>  arch/x86/pci/pcbios.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20120313.orig/arch/x86/pci/pcbios.c
> +++ linux-next-20120313/arch/x86/pci/pcbios.c
> @@ -27,6 +27,7 @@
>  #define PCIBIOS_HW_TYPE2_SPEC		0x20
>  
>  int pcibios_enabled;
> +EXPORT_SYMBOL(pcibios_enabled);
>  
>  /* According to the BIOS specification at:
>   * http://members.datafast.net.au/dft0802/specs/bios21.pdf, we could

I would think this should be EXPORT_SYMBOL_GPL()... this seems like a
symbol with a very high likelihood to be abused in strange ways.

	-hpa

