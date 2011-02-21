Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab1BUJnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 04:43:24 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60826 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab1BUJnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 04:43:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Eh8hi336E79Chk1O8c4QZAB1J0vRxbeA3ZAhqfNWucn0Su4cY6cA4NwEwbxR1B7zf4
         hPRDqurCXpZQLNCX8N1iM6BBbmPFW9ffShYOL9XClqcm9+wftwJL0qwHoU3PT7z8uwgA
         /WKZAVfVxQouiqgikIiznI57jZDdJgjJY9WZw=
Date: Mon, 21 Feb 2011 10:43:18 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 2/4] x86, numa: Do not adjust start/end for
 early_node_mem()
Message-ID: <20110221094318.GG31267@htj.dyndns.org>
References: <4D5EC05A.60103@kernel.org>
 <4D5EC184.6000505@kernel.org>
 <alpine.DEB.2.00.1102191944530.32280@chino.kir.corp.google.com>
 <AANLkTikgR8vEhz3Hsmx96QqZw_gsLZetc3W_9evf3ufb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikgR8vEhz3Hsmx96QqZw_gsLZetc3W_9evf3ufb@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Feb 19, 2011 at 08:17:11PM -0800, Yinghai Lu wrote:
> > The old code guarantees that the range is from a single zone, and even
> > though memblock may be top -> down, it seems like there would be
> > configurations where this would still be an issue (perhaps simulating it
> > with numa=fake for testing?) if it crosses the boundary.
> 
> memblock_x86_find_in_range_node() will go over with early_node_map[].
> so it will always can get right on node allocation.

I think always doing top-down allocation should be enough as long as
there's no highmem, which we don't have on 64bit.  That said, the
patch description should note the behavior difference.  Yinghai, care
to add a bit more detail to the patch description?

Thanks.

-- 
tejun
