Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab1GKRts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 13:49:48 -0400
Received: from smtp-out.google.com ([216.239.44.51]:33934 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab1GKRtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 13:49:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=YGeezqDNcLBUml4GTumuzMxHFCo6uaZ0XgORfsQrCjMoHdrXFYUeeFJm3iw/AcPBe
	5DzUoshSg2hUNj3mowsbA==
Date: Mon, 11 Jul 2011 10:49:31 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Andrew Morton <akpm@linux-foundation.org>, greg@kroah.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 34/49] gma500: the GEM and GTT code is device
 independant
In-Reply-To: <20110711172517.46907e62@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LSU.2.00.1107111033440.1752@sister.anvils>
References: <20110705141038.23872.55303.stgit@localhost.localdomain> <20110705144140.23872.86541.stgit@localhost.localdomain> <alpine.LSU.2.00.1107071742250.10362@sister.anvils> <20110708093859.299958df@lxorguk.ukuu.org.uk> <alpine.LSU.2.00.1107080917430.1781@sister.anvils>
 <20110711172517.46907e62@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011, Alan Cox wrote:
> > Your <4GB pages won't get swapped out while they're pinned.  But can
> > it happen that they'd be unpinned, swapped out, swapped back in >4GB
> > pages, then cause trouble for you when needed again?
> 
> It does look that way, in which case that will eventually need fixing. At
> the moment you can't put enough memory into a device using these chips
> but that won't always be true I imagine.

Thanks, I won't worry about it at this moment, but we'd better not forget.

If it's easy for you to include a WARN_ON_ONCE check (perhaps
on page_to_pfn(page)), that may be worth doing to remind us.

It's a bit sad to learn this requirement just after I'd completed
removing the readpage copying code, and a bit strange to have shmem
confined by hardware constraints; but I guess that's what we took on
when we opened it up to GEM.

It will probably make sense for me to add synchronous migration when
a shmem swap page is found not to match the contraints wanted by the
mapping it goes into: mainly for NUMA, but covering your case too.

Hugh
