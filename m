Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662Ab2ERJZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 05:25:34 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:58405 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932852Ab2ERJZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 05:25:31 -0400
Date: Fri, 18 May 2012 12:25:26 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Joonsoo Kim <js1304@gmail.com>
cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH RESEND] slub: fix a memory leak in get_partial_node()
In-Reply-To: <1337181182-23054-1-git-send-email-js1304@gmail.com>
Message-ID: <alpine.LFD.2.02.1205181223460.3899@tux.localdomain>
References: <alpine.LFD.2.02.1205160935340.1763@tux.localdomain> <1337181182-23054-1-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2012, Joonsoo Kim wrote:
> In the case which is below,
> 
> 1. acquire slab for cpu partial list
> 2. free object to it by remote cpu
> 3. page->freelist = t
> 
> then memory leak is occurred.
> 
> Change acquire_slab() not to zap freelist when it works for cpu partial list.
> I think it is a sufficient solution for fixing a memory leak.
> 
> Below is output of 'slabinfo -r kmalloc-256'
> when './perf stat -r 30 hackbench 50 process 4000 > /dev/null' is done.
> 
> ***Vanilla***
> Sizes (bytes)     Slabs              Debug                Memory
> ------------------------------------------------------------------------
> Object :     256  Total  :     468   Sanity Checks : Off  Total: 3833856
> SlabObj:     256  Full   :     111   Redzoning     : Off  Used : 2004992
> SlabSiz:    8192  Partial:     302   Poisoning     : Off  Loss : 1828864
> Loss   :       0  CpuSlab:      55   Tracking      : Off  Lalig:       0
> Align  :       8  Objects:      32   Tracing       : Off  Lpadd:       0
> 
> ***Patched***
> Sizes (bytes)     Slabs              Debug                Memory
> ------------------------------------------------------------------------
> Object :     256  Total  :     300   Sanity Checks : Off  Total: 2457600
> SlabObj:     256  Full   :     204   Redzoning     : Off  Used : 2348800
> SlabSiz:    8192  Partial:      33   Poisoning     : Off  Loss :  108800
> Loss   :       0  CpuSlab:      63   Tracking      : Off  Lalig:       0
> Align  :       8  Objects:      32   Tracing       : Off  Lpadd:       0
> 
> Total and loss number is the impact of this patch.
> 
> Cc: <stable@vger.kernel.org>
> Acked-by: Christoph Lameter <cl@linux.com>
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>

Applied, thanks!
