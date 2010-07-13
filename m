Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab0GMGZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 02:25:26 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55931 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab0GMGZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 02:25:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 13 Jul 2010 15:20:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 3/7] Update the [register,unregister]_memory routines
Message-Id: <20100713152044.7ec8c9ae.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C3B384A.4000902@austin.ibm.com>
References: <4C3B3446.5090302@austin.ibm.com>
	<4C3B384A.4000902@austin.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010 10:44:10 -0500
Nathan Fontenot <nfont@austin.ibm.com> wrote:

> This patch moves the register/unregister_memory routines to
> avoid a forward declaration.  It also moves the sysfs file
> creation and deletion for each directory into the register/
> unregister routines to avoid duplicating it with these updates.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
> ---
>  drivers/base/memory.c |   93 +++++++++++++++++++++++++-------------------------
>  1 file changed, 48 insertions(+), 45 deletions(-)
> 
> Index: linux-2.6/drivers/base/memory.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/memory.c	2010-07-09 14:23:17.000000000 -0500
> +++ linux-2.6/drivers/base/memory.c	2010-07-09 14:23:20.000000000 -0500
> @@ -87,31 +87,6 @@
>  EXPORT_SYMBOL(unregister_memory_isolate_notifier);
>  
>  /*
> - * register_memory - Setup a sysfs device for a memory block
> - */
> -static
> -int register_memory(struct memory_block *memory, struct mem_section *section)
> -{
> -	int error;
> -
> -	memory->sysdev.cls = &memory_sysdev_class;
> -	memory->sysdev.id = __section_nr(section);
> -
> -	error = sysdev_register(&memory->sysdev);
> -	return error;
> -}
> -
> -static void
> -unregister_memory(struct memory_block *memory)
> -{
> -	BUG_ON(memory->sysdev.cls != &memory_sysdev_class);
> -
> -	/* drop the ref. we got in remove_memory_block() */
> -	kobject_put(&memory->sysdev.kobj);
> -	sysdev_unregister(&memory->sysdev);
> -}
> -
> -/*
>   * use this as the physical section index that this memsection
>   * uses.
>   */
> @@ -346,6 +321,53 @@
>  	sysdev_remove_file(&mem->sysdev, &attr_##attr_name)
>  
>  /*
> + * register_memory - Setup a sysfs device for a memory block
> + */
> +static
> +int register_memory(struct memory_block *memory, struct mem_section *section,
> +		    int nid, enum mem_add_context context)
> +{
> +	int ret;
> +
> +	memory->sysdev.cls = &memory_sysdev_class;
> +	memory->sysdev.id = __section_nr(section);
> +
Why not block-ID  but section-ID ?

-Kame

