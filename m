Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab1AaNcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 08:32:14 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44392 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515Ab1AaNcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 08:32:13 -0500
Message-ID: <4D46B9A9.1060205@vflare.org>
Date: Mon, 31 Jan 2011 08:31:21 -0500
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] zram/xvmalloc: combine duplicate block delete code
References: <20110128145602.GA2062@linux.vnet.ibm.com> <20110128150155.GH2062@linux.vnet.ibm.com>
In-Reply-To: <20110128150155.GH2062@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2011 10:01 AM, Robert Jennings wrote:
> This patch eliminates duplicate code.  The remove_block_head function
> is a special case of remove_block which can be contained in remove_block
> without confusion.
>
> The portion of code in remove_block_head which was noted as "DEBUG ONLY"
> is now mandatory.  Doing this provides consistent management of the double
> linked list of blocks under a freelist and makes this consolidation
> of delete block code safe.  The first and last blocks will have NULL
> pointers in their previous and next page pointers respectively.
>
> Additionally, any time a block is removed from a free list the next and
> previous pointers will be set to NULL to avoid misuse outside xvmalloc.
>
> Signed-off-by: Robert Jennings<rcj@linux.vnet.ibm.com>

The reason for introducing remove_block_head() as a separate function 
was to make malloc slightly faster but since I lack any profiling data, 
I'm not very sure if this may impact performance. Ideally, some sort of 
data with some malloc heavy test would have been useful. Anyways, I 
think major allocator changes will happen when we make xvmalloc 
allocated memory reclaimable, so maybe we can defer profiling.

Acked-by: Nitin Gupta <ngupta@vflare.org>

Thanks,
Nitin
