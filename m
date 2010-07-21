Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab0GUU1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 16:27:37 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:33899 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab0GUU1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 16:27:34 -0400
Message-ID: <4C475827.8040605@linux.vnet.ibm.com>
Date: Wed, 21 Jul 2010 15:27:19 -0500
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Nathan Fontenot <nfont@austin.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        greg@kroah.com, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 7/8] v3 Define memory_block_size_bytes() for ppc/pseries
References: <4C451BF5.50304@austin.ibm.com> <4C451F05.9010502@austin.ibm.com>
In-Reply-To: <4C451F05.9010502@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2010 10:59 PM, Nathan Fontenot wrote:
> 
> +static u32 get_memblock_size(void)
> +{
> +	struct device_node *np;
> +	unsigned int memblock_size = 0;
> +
> +	np = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
> +	if (np) {
> +		const unsigned int *size;

This needs to be an unsigned long, otherwise I always get zero on my p6.

> +
> +		size = of_get_property(np, "ibm,lmb-size", NULL);
> +		memblock_size = size ? *size : 0;
> +
> +		of_node_put(np);



-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


