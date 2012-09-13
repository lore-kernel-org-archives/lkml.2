Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab2IMTcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 15:32:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47947 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab2IMTcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 15:32:14 -0400
Date: Thu, 13 Sep 2012 12:32:09 -0700
From: Tejun Heo <tj@kernel.org>
To: Cyril Chemparathy <cyril@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, davem@davemloft.net, eric.dumazet@gmail.com,
        hannes@cmpxchg.org, shangw@linux.vnet.ibm.com, vitalya@ti.com
Subject: Re: [PATCH] mm: bootmem: use phys_addr_t for physical addresses
Message-ID: <20120913193209.GL7677@google.com>
References: <1347466008-7231-1-git-send-email-cyril@ti.com>
 <20120912203920.GU7677@google.com>
 <505123FE.2090305@ti.com>
 <20120913003400.GA25889@localhost>
 <50512B9A.9060905@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50512B9A.9060905@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Cyril.

On Wed, Sep 12, 2012 at 08:40:58PM -0400, Cyril Chemparathy wrote:
> You probably missed the lowmem bit from my response?
> 
> This system has all of its memory outside the 4GB physical address
> space.  This includes lowmem, which is permanently mapped into the
> kernel virtual address space as usual.

Yeah, I understand that and as a short-term solution we maybe can add
a check to verify that the goal and limits are under lowmem and fail
with NULL if not, but it still is a broken interface and I'd rather
not mess with it when memblock is already there.  Converting to
memblock usually isn't too much work although it expectedly involves
some subtleties and fallouts for a while.

Do you recall what the problem was with sparsemem and memblock?  I
don't think I'll directly work on arm but I'll be happy to help on
memblock issues.

Thanks.

-- 
tejun
