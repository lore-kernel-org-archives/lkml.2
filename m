Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab0I1MsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 08:48:15 -0400
Received: from relay2.sgi.com ([192.48.179.30]:46781 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753302Ab0I1MsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 08:48:14 -0400
Date: Tue, 28 Sep 2010 07:48:10 -0500
From: Robin Holt <holt@sgi.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        Greg KH <greg@kroah.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 4/8] v2 Allow memory block to span multiple memory
 sections
Message-ID: <20100928124810.GI14068@sgi.com>
References: <4CA0EBEB.1030204@austin.ibm.com>
 <4CA0EFAA.8050000@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA0EFAA.8050000@austin.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +u32 __weak memory_block_size_bytes(void)
> +{
> +	return MIN_MEMORY_BLOCK_SIZE;
> +}
> +
> +static u32 get_memory_block_size(void)

Can we make this an unsigned long?  We are testing on a system whose
smallest possible configuration is 4GB per socket with 512 sockets.
We would like to be able to specify this as 2GB by default (results
in the least lost memory) and suggest we add a command line option
which overrides this value.  We have many installations where 16GB may
be optimal.  Large configurations will certainly become more prevalent.

...
> @@ -551,12 +608,16 @@
>  	unsigned int i;
>  	int ret;
>  	int err;
> +	int block_sz;

This one needs to match the return above.  In our tests, we ended up
with a negative sections_per_block which caused very unexpected results.

Robin
