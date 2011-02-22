Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab1BVKj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 05:39:26 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56899 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab1BVKjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 05:39:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Efu9lev0/CWTjNvifcHD3C5ypPRieI5UPnmRZcCRvn+h+UAdiU882Yqpmk22xiXhUL
         vYIyjjRMvGh7zlG1NWrmYDngHioN5oFzodRMB649K/6/1sBUS+S7A9nGuvjoGfOnSBCl
         +s6vyE/p2Fh0PffAEWjorEpU0y4KBL/tvywvQ=
Date: Tue, 22 Feb 2011 11:39:20 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 2/4] x86, numa: Do not adjust start/end for
 early_node_mem()
Message-ID: <20110222103920.GY31267@htj.dyndns.org>
References: <4D5EC05A.60103@kernel.org>
 <4D5EC184.6000505@kernel.org>
 <alpine.DEB.2.00.1102191944530.32280@chino.kir.corp.google.com>
 <AANLkTikgR8vEhz3Hsmx96QqZw_gsLZetc3W_9evf3ufb@mail.gmail.com>
 <20110221094318.GG31267@htj.dyndns.org>
 <20110221104443.GJ31267@htj.dyndns.org>
 <4D62CAE4.4040207@kernel.org>
 <20110222103653.GX31267@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222103653.GX31267@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 11:36:53AM +0100, Tejun Heo wrote:
> So, don't remove the DMA boundary limit.  Even if the current code
> wouldn't result in that (and the current code CAN), it is a good
> sanity check to have because you don't want memory map under 16MiB no
> matter what.

Oh, if you're genuinely concerned about machines which wouldn't be
able to allocate memory map because it doesn't have enough memory
above 16MiB, the correct thing to do is removing the boundary limit
from the fallback generic allocation, NOT from the NUMA aware
allocation.

-- 
tejun
