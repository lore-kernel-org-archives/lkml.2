Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933708Ab0FRQpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 12:45:21 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:39581 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761291Ab0FRQpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 12:45:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=dw8ftNVPS4svDlgqcciyqMVPdtirG0mhVBfliRtLZi+XiYb3CziWOos3aWZaV8+9fXxKjcEQjB0rnB5zFLsKeibHwYKDZqBgHGvF7X1krDcXSpT4ylwq5s//S1ZvcF9f;
Date: Fri, 18 Jun 2010 09:43:40 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/1] X86: pci, fix section mismatch
Message-ID: <20100618094340.65ce15d8@virtuousgeek.org>
In-Reply-To: <1276609399-21746-1-git-send-email-jslaby@suse.cz>
References: <1276609399-21746-1-git-send-email-jslaby@suse.cz>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jun 2010 15:43:19 +0200
Jiri Slaby <jslaby@suse.cz> wrote:

> pcibios_scan_specific_bus calls pci_scan_bus_on_node which is
> __devinit. Mark pcibios_scan_specific_bus __devinit as well since
> all users are now __init or __devinit.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: linux-pci@vger.kernel.org
> Cc: x86@kernel.org
> ---
>  arch/x86/pci/legacy.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
> index 8d460ea..c89266b 100644
> --- a/arch/x86/pci/legacy.c
> +++ b/arch/x86/pci/legacy.c
> @@ -36,7 +36,7 @@ int __init pci_legacy_init(void)
>  	return 0;
>  }
>  
> -void pcibios_scan_specific_bus(int busn)
> +void __devinit pcibios_scan_specific_bus(int busn)
>  {
>  	int devfn;
>  	long node;

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
