Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965075Ab2EOPPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:15:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65492 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965021Ab2EOPPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:15:14 -0400
Date: Tue, 15 May 2012 08:15:09 -0700
From: Tejun Heo <tj@kernel.org>
To: Stephen Boyd <sboyd@quicinc.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: memblock_is_region_memory() vs. memblock_is_region_reserved()
Message-ID: <20120515151509.GC6119@google.com>
References: <4FB1AD38.7000503@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB1AD38.7000503@quicinc.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 06:11:20PM -0700, Stephen Boyd wrote:
> I was looking at memblock and noticed that memblock_is_region_memory()
> is implemented differently than memblock_is_region_reserved().
> 
> memblock_is_region_memory() returns true only if the region you are
> testing is fully contained within the bounds of a memory block. If the
> region is half in and half out of a memory region (i.e. overlaps memory
> and a hole) it is not memory and returns false.
> 
> memblock_is_region_reserved() is the opposite. If the region are you are
> testing is half in and half out of a reserved region (i.e. overlaps
> reserved memory) it returns true, otherwise it returns false.
> 
> These functions sound like they do the same thing by testing to see if
> what you specify is either memory or reserved memory, but the semantics
> are a bit different in that the former doesn't allow overlap, and the
> latter accepts overlap. Should we rename memblock_is_region_reserved()
> to memblock_overlaps_reserved() to make it clearer what the intention
> is? Or perhaps rename memblock_is_region_memory() to
> memblock_is_region_within_memory()?

The difference is there because for a memory region to be available,
all of it should be while a memory region partially reserved should
still be treated as reserved.

> If anything, perhaps this patch will help clarify things?

Yeah, looks good to me.  Can you please add patch description,
sign-off and send it to Ingo?

Thanks.

-- 
tejun
