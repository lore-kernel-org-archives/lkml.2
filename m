Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab1BUKot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 05:44:49 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54582 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab1BUKos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 05:44:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pN1zulRifa/VVtFTyYkXwvk0Q4bV5muB+QMlygQ3Cv+80AoDr9cIfQ8iIJTSxm8GjG
         uN3XCz3Akydeng0FGTFiBLkVGGePrA+gB9nQ4kBeDuwrgFGq4vfpQgiLgQIiUerRJY//
         KasalChDAKYhbypyrKkRHP2blyqKPKOZFIYUc=
Date: Mon, 21 Feb 2011 11:44:43 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 2/4] x86, numa: Do not adjust start/end for
 early_node_mem()
Message-ID: <20110221104443.GJ31267@htj.dyndns.org>
References: <4D5EC05A.60103@kernel.org>
 <4D5EC184.6000505@kernel.org>
 <alpine.DEB.2.00.1102191944530.32280@chino.kir.corp.google.com>
 <AANLkTikgR8vEhz3Hsmx96QqZw_gsLZetc3W_9evf3ufb@mail.gmail.com>
 <20110221094318.GG31267@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110221094318.GG31267@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 10:43:18AM +0100, Tejun Heo wrote:
> Hello,
> 
> On Sat, Feb 19, 2011 at 08:17:11PM -0800, Yinghai Lu wrote:
> > > The old code guarantees that the range is from a single zone, and even
> > > though memblock may be top -> down, it seems like there would be
> > > configurations where this would still be an issue (perhaps simulating it
> > > with numa=fake for testing?) if it crosses the boundary.
> > 
> > memblock_x86_find_in_range_node() will go over with early_node_map[].
> > so it will always can get right on node allocation.
> 
> I think always doing top-down allocation should be enough as long as
> there's no highmem, which we don't have on 64bit.  That said, the
> patch description should note the behavior difference.  Yinghai, care
> to add a bit more detail to the patch description?

Hmmm... thinking more about it, there actually is a difference.
Depending on configuration, the new code allows node_data[] to be
allocated below DMA boundary.  I think we need to keep the first if().
Areas crossing the boundaries is okay, in fact, the original code
already allowed that when the NUMA affine allocation failed; however,
node_data[] was never allowed below the DMA boundary and I think it
shouldn't be.

Thanks.

-- 
tejun
