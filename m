Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057Ab0FKRpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 13:45:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58644 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757198Ab0FKRoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 13:44:54 -0400
Message-ID: <4C127604.6000203@zytor.com>
Date: Fri, 11 Jun 2010 10:44:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org
Subject: Re: [PATCH 3/4] x86: ioremap: remove physical address warning message
References: <4C11FF10.4060203@jp.fujitsu.com> <4C11FFF6.8040406@jp.fujitsu.com>
In-Reply-To: <4C11FFF6.8040406@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2010 02:20 AM, Kenji Kaneshige wrote:
> Current ioremap() code for x86 displays warning message if too high
> address to handle is passed. But this can happen as usual cases. For
> example, if 64-bit BAR is assigned to a PCI device and its device
> driver calls pci_iomap(). So this patch changes the warning messages
> as follows.
> 
> - Change printk message from KERN_WARNING to KERN_DEBUG
> - Remove WARN_ON_ONCE()
> 
> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> 
> ---
>  arch/x86/mm/ioremap.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> Index: linux-2.6.34/arch/x86/mm/ioremap.c
> ===================================================================
> --- linux-2.6.34.orig/arch/x86/mm/ioremap.c	2010-06-10 07:28:31.966187993 +0900
> +++ linux-2.6.34/arch/x86/mm/ioremap.c	2010-06-10 07:28:33.146375380 +0900
> @@ -78,9 +78,8 @@
>  		return NULL;
>  
>  	if (!phys_addr_valid(phys_addr)) {
> -		printk(KERN_WARNING "ioremap: invalid physical address %llx\n",
> +		printk(KERN_DEBUG "ioremap: can't map physical address %llx\n",
>  		       (unsigned long long)phys_addr);
> -		WARN_ON_ONCE(1);
>  		return NULL;
>  	}
>  

Fair to change the message, but the priority level really seems way
insufficient.  I can see dropping the WARN_ON_ONCE() though.

	-hpa
