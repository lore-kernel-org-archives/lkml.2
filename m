Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab0CVLvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 07:51:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630Ab0CVLvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 07:51:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1268989324-7575-1-git-send-email-graff.yang@gmail.com>
References: <1268989324-7575-1-git-send-email-graff.yang@gmail.com>
To: graff.yang@gmail.com
Cc: dhowells@redhat.com, tj@kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] mm/nommu.c:Dynamic alloc/free percpu area for nommu
Date: Mon, 22 Mar 2010 11:50:39 +0000
Message-ID: <28495.1269258639@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<graff.yang@gmail.com> wrote:

> -	return virt_to_page(addr);
> +	return (struct page *)
> +			(virt_to_page(addr)->index) ? : virt_to_page(addr);

Can the extra conditional operator be made subject to CONFIG_SMP?

> -	return page_to_pfn(virt_to_page(addr));
> +	return page_to_pfn((struct page *)
> +			(virt_to_page(addr)->index) ? : virt_to_page(addr));

Ditto.

> +#ifdef CONFIG_SMP
> ...
> +#endif

Can this be put into a separate file?  There's rather a lot in mm/nommu.c
these days.

David
