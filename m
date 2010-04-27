Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab0D0RIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 13:08:21 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41712 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107Ab0D0RIT (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 27 Apr 2010 13:08:19 -0400
Date: Tue, 27 Apr 2010 13:07:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [LKML] [PATCH -mm 0/6] remove unnecessary sync_single_range_*
	in dma_map_ops
Message-ID: <20100427170715.GA24826@phenom.dumpdata.com>
References: <1272371140-6085-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272371140-6085-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090206.4BD719DB.0045:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 09:25:34PM +0900, FUJITA Tomonori wrote:
> This patchset removes useless sync_single_range_for_cpu and
> sync_single_range_for_device hooks in dma_map_ops. These hooks were
> for dma_sync_single_range_* DMA API, however, the API became obsolete
> (the description in DMA API docs was removed too). Architecutres
> should use sync_single_for_cpu and sync_single_for_device hooks
> instead (as DMA API docs say, they need to support a partial sync).
> 
> We could remove dma_sync_single_range_* DMA API completely (no user in
> -mm) but the API had been until 2.6.34-rc so I guess that it might be
> better to leave it alone for some time.
> 
> The first patch is a bug fix and might be 2.6.34-rc material however
> the API is not so popular (only net/b44.c uses) and we are already in
> -rc5. I guess that it would be fine to merge it in the next merge
> window.

Not sure if this is needed since the patches aren't that complex, but I
did do a review of all of them. Hence:

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
