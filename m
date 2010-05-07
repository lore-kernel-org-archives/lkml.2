Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab0EGUuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 16:50:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754719Ab0EGUup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 16:50:45 -0400
Date: Fri, 7 May 2010 13:50:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: minskey guo <chaohong_guo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       "Kleen, Andi" <andi.kleen@intel.com>
Subject: Re: [PATCH] CPU/mem hotplug:  enable CPUs online before local
 memory online
Message-Id: <20100507135042.5710d330.akpm@linux-foundation.org>
In-Reply-To: <4BE3AA3C.4080507@linux.intel.com>
References: <4BE3AA3C.4080507@linux.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 May 2010 13:50:52 +0800
minskey guo <chaohong_guo@linux.intel.com> wrote:

> This patch enables users to online CPUs even if the CPUs belongs to
> a numa node which doesn't have onlined local memory.
> 
> The zonlists(pg_data_t.node_zonelists[]) of a numa node are created
> either in system boot/init period, or at the time of local memory
> online.  For a numa node without onlined local memory, its zonelists
> are not initialized at present. As a result, any memory allocation
> operations executed by CPUs within this node will fail. In fact, an
> out-of-memory error is triggered when attempt to online CPUs before
> memory comes to online.
> 
> This patch tries to create zonelists for such numa nodes, so that
> the memory allocation for this node can be fallback'ed to other
> nodes.

I had a horrible time extracting a usable patch from this email. 
Please don't send two copies of a patch in a single email.  One version
was space-stuffed and the other had text/plain mimetype.  text/plain
attachents are OK.  Plain old inlined text is preferred, but first
email yourself a test patch to check that it isn't getting mangled. 
Make sure that the patch has lines longer than 100 chars to check for
wordwrapping.


I removed the unneeded EXPORT_SYMBOL_GPL(mem_online_node);
