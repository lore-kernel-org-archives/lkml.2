Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab0FNShV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 14:37:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43271 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab0FNShS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 14:37:18 -0400
Message-ID: <4C1676C0.60105@zytor.com>
Date: Mon, 14 Jun 2010 11:36:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org
Subject: Re: [PATCH 2/4] x86: ioremap: fix physical address check
References: <4C11FF10.4060203@jp.fujitsu.com>	<4C11FFC0.1030006@jp.fujitsu.com>	<4C1275BF.3070605@zytor.com>	<20100614091823.34fac7a6.kamezawa.hiroyu@jp.fujitsu.com> <20100614175912.976f5878.kamezawa.hiroyu@jp.fujitsu.com> <4C15F2BD.9020904@jp.fujitsu.com> <4C160D27.1050809@jp.fujitsu.com>
In-Reply-To: <4C160D27.1050809@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 04:06 AM, Kenji Kaneshige wrote:
> Index: linux-2.6.34/include/linux/vmalloc.h
> ===================================================================
> --- linux-2.6.34.orig/include/linux/vmalloc.h
> +++ linux-2.6.34/include/linux/vmalloc.h
> @@ -30,7 +30,7 @@ struct vm_struct {
>  	unsigned long		flags;
>  	struct page		**pages;
>  	unsigned int		nr_pages;
> -	unsigned long		phys_addr;
> +	phys_addr_t		phys_addr;
>  	void			*caller;
>  };

This really doesn't look right at all.  If this was required then it
would seem that anything using high addresses would be broken... as such
I can only assume it matters only for lowmem pages...

	-hpa
