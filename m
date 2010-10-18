Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008Ab0JRRFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 13:05:49 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34305 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab0JRRFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 13:05:48 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4CBC7D62.6040408@s5r6.in-berlin.de>
Date: Mon, 18 Oct 2010 19:01:22 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Tom Brown <sa212+emis@cyconix.com>
CC: LKML <linux-kernel@vger.kernel.org>, Yong Zhang <yong.zhang@windriver.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: Question: how to copy to user space from a tasklet
References: <4CB6DEC4.4040408@cyconix.com> <4CB7ED67.2000407@s5r6.in-berlin.de> <4CBC6BA0.60507@cyconix.com>
In-Reply-To: <4CBC6BA0.60507@cyconix.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Brown wrote:
> Thanks, think I'm there:
> 
> 1 - The user calls mmap() with a specific offset to flag that he wants a
> DMA buffer
> 
> 2 - I then 'vmalloc' the buffer, and call 'setPageReserved' for each page
> 
> I then step over each page, and:
> 
> 3 - call 'vmalloc_to_pfn' to get a PFN for each page, and then
> 
> 4 - call 'remap_page_range' for that page (I instead call
> 'remap_pfn_range' for kernels >= 2.6.10, but I'm on 2.6.9)
> 
> This gives me the buffer, and the interrupt handler then just uses
> 'memcpy' to copy data to the user.

I would have thought of a bunch of alloc_page() and vm_insert_page() but I
don't know if vm_insert_page exists in 2.6.9 and if it honors user limits.

Plus dma_map_page() to get zero-copy operation with a DMA capable device.
-- 
Stefan Richter
-=====-==-=- =-=- =--=-
http://arcgraph.de/sr/
