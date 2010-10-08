Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab0JHWQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 18:16:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56970 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab0JHWQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 18:16:33 -0400
Message-ID: <4CAF97E8.7000505@kernel.org>
Date: Fri, 08 Oct 2010 15:15:04 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Russ Anderson <rja@sgi.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
        "H. Peter Anvin" <h.peter.anvin@intel.com>,
        Jack Steiner <steiner@sgi.com>
Subject: Re: [BUG] x86: bootmem broken on SGI UV
References: <20101008213429.GB7223@sgi.com>
In-Reply-To: <20101008213429.GB7223@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2010 02:34 PM, Russ Anderson wrote:
> 	[BUG] x86: bootmem broken on SGI UV
> 
> Recent community kernels do not boot on SGI UV x86 hardware with
> more than one socket.  I suspect the problem is due to recent 
> bootmem/e820 changes.
> 
> What is happening is the e280 table defines a memory range.
> 
>  BIOS-e820: 0000000100000000 - 0000001080000000 (usable)
> 
> The SRAT table shows that memory range is spread over two nodes.
> 
>  SRAT: Node 0 PXM 0 100000000-800000000
>  SRAT: Node 1 PXM 1 800000000-1000000000
>  SRAT: Node 0 PXM 0 1000000000-1080000000
> 
> Previously, the kernel early_node_map[] would show three entries
> with the proper node.
>                                                                                 
> [    0.000000]     0: 0x00100000 -> 0x00800000
> [    0.000000]     1: 0x00800000 -> 0x01000000
> [    0.000000]     0: 0x01000000 -> 0x01080000
> 
> The problem is recent community kernel early_node_map[] shows 
> only two entries with the node 0 entry overlapping the node 1
> entry.
> 
>     0: 0x00100000 -> 0x01080000
>     1: 0x00800000 -> 0x01000000
> 

found the root cause, will send patch out today or tomorrow.

Thanks

Yinghai
