Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761450Ab0GTTVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 15:21:33 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:37415 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758567Ab0GTTVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 15:21:32 -0400
Subject: Re: [PATCH 4/8] v3 Allow memory_block to span multiple memory
 sections
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, greg@kroah.com
In-Reply-To: <4C451E1C.8070907@austin.ibm.com>
References: <4C451BF5.50304@austin.ibm.com>
	 <4C451E1C.8070907@austin.ibm.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Tue, 20 Jul 2010 12:21:20 -0700
Message-ID: <1279653680.9785.5.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-19 at 22:55 -0500, Nathan Fontenot wrote:
> +static u32 get_memory_block_size(void)
> +{
> +       u32 block_sz;
> +
> +       block_sz = memory_block_size_bytes();
> +
> +       /* Validate blk_sz is a power of 2 and not less than section size */
> +       if ((block_sz & (block_sz - 1)) || (block_sz < MIN_MEMORY_BLOCK_SIZE))
> +               block_sz = MIN_MEMORY_BLOCK_SIZE;

Is this worth a WARN_ON()?  Seems pretty bogus if someone is returning
funky block sizes.  

-- Dave

