Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab0HYIYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 04:24:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:39725 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225Ab0HYIYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 04:24:20 -0400
Message-ID: <4C74D1D7.4080608@kernel.org>
Date: Wed, 25 Aug 2010 10:18:31 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (slab
 tree related)
References: <20100824120714.8918f8de.sfr@canb.auug.org.au> <4C740450.3030000@cs.helsinki.fi> <alpine.DEB.2.00.1008241256280.4763@router.home> <4C741029.7090300@cs.helsinki.fi> <alpine.DEB.2.00.1008241352240.5388@router.home>
In-Reply-To: <alpine.DEB.2.00.1008241352240.5388@router.home>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 25 Aug 2010 08:23:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/24/2010 08:53 PM, Christoph Lameter wrote:
>> [    0.000000] Kernel panic - not syncing: Cannot create slab kmem_cache
>> size=232 realsize=256 order=0 offset=0 flags=42000
> 
> alloc per cpu result in kmalloc which fails.
> 
> Tejon: Is there some way we could get a reserved per cpu area under UP
> instead of fallback to slab allocations during bootup?

Eh... nasty.  Maybe we can create a alloc_percpu_early() function
which doesn't allow freeing of allocate memory and just redirect to
bootmem on UP?

-- 
tejun
