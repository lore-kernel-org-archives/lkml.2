Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab0IHTmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 15:42:38 -0400
Received: from plane.gmane.org ([80.91.229.3]:42250 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161Ab0IHTme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 15:42:34 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Cliff Wickman <public-cpw-sJ/iWh9BUns@plane.gmane.org>
Cc: public-kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@plane.gmane.org,
        public-mingo-X9Un+BFzKDI@plane.gmane.org,
        public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org
Subject: Re: [PATCH] x86: copy_oldmem_page using cached addressing
References: <E1OtMLz-0001yp-Ia@eag09.americas.sgi.com>
Date: Wed, 08 Sep 2010 21:42:18 +0200
In-Reply-To: <E1OtMLz-0001yp-Ia@eag09.americas.sgi.com> (Cliff Wickman's
	message of "Wed, 08 Sep 2010 10:14:27 -0500")
Message-ID: <87eid4vx7p.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Cliff Wickman <cpw-sJ/iWh9BUns@public.gmane.org> writes:

> From: Cliff Wickman <cpw-sJ/iWh9BUns@public.gmane.org>
>
> The copy of /proc/vmcore to a user buffer proceeds much faster
> if the kernel addresses memory as cached.
>
> With this patch we have seen an increase in transfer rate from less than
> 15MB/s to 80-460MB/s, depending on size of the transfer.  This makes
> a big difference in time needed to save a system dump.
>
> (Does anyone know of a reason why copy_oldmem_page() would need
>  to use uncached addresses?)
>
> Diffed against 2.6.36-rc3

I had a similar patch somewhere in my private kernels,
yes it's a big win. I think it was simply a bug that was added
when ioremap was changed to default to uncached.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

