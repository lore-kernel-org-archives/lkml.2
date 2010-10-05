Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab0JEFN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 01:13:58 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41692 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab0JEFN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 01:13:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 5 Oct 2010 14:08:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, Greg KH <greg@kroah.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Robin Holt <holt@sgi.com>,
        steiner@sgi.com
Subject: Re: [PATCH 3/9] v3 Add section count to memory_block struct
Message-Id: <20101005140835.9c80c2e7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4CA628D0.6030508@austin.ibm.com>
References: <4CA62700.7010809@austin.ibm.com>
	<4CA628D0.6030508@austin.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Oct 2010 13:30:40 -0500
Nathan Fontenot <nfont@austin.ibm.com> wrote:

> Add a section count property to the memory_block struct to track the number
> of memory sections that have been added/removed from a memory block. This
> allows us to know when the last memory section of a memory block has been
> removed so we can remove the memory block.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
> 

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

a nitpick,


> Index: linux-next/include/linux/memory.h
> ===================================================================
> --- linux-next.orig/include/linux/memory.h	2010-09-29 14:56:29.000000000 -0500
> +++ linux-next/include/linux/memory.h	2010-09-30 14:13:50.000000000 -0500
> @@ -23,6 +23,8 @@
>  struct memory_block {
>  	unsigned long phys_index;
>  	unsigned long state;
> +	int section_count;

I prefer
	int section_count; /* updated under mutex */

or some for this kind of non-atomic counters. but nitpick.

