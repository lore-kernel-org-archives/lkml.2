Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab0GMK4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 06:56:24 -0400
Received: from elasmtp-spurfowl.atl.sa.earthlink.net ([209.86.89.66]:60891
	"EHLO elasmtp-spurfowl.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751642Ab0GMK4W convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 06:56:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=BuzAaPp6ud4nlz5qKs7OogBTVEvV5zFAzUrE9s19FxT8fcB3vUALBPdHlJ8ACzxy;
  h=Received:Subject:Mime-Version:Content-Type:From:In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:To:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Subject: Re: [PATCH -mmotm 12/30] selinux: tag avc cache alloc as non-critical
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Mitchell Erblich <erblichs@earthlink.net>
In-Reply-To: <20100713101906.2835.83443.sendpatchset@danny.redhat>
Date: Tue, 13 Jul 2010 03:55:55 -0700
Cc: linux-mm@kvack.org, linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        riel@redhat.com, cl@linux-foundation.org, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, lwang@redhat.com, penberg@cs.helsinki.fi,
        akpm@linux-foundation.org, davem@davemloft.net
Content-Transfer-Encoding: 8BIT
Message-Id: <6E38A74E-B033-4D2A-9620-2A8BDF9E0AD1@earthlink.net>
References: <20100713101650.2835.15245.sendpatchset@danny.redhat> <20100713101906.2835.83443.sendpatchset@danny.redhat>
To: Xiaotian Feng <dfeng@redhat.com>
X-Mailer: Apple Mail (2.1081)
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec79ffa7380785fb8576cbc132ff1f9bbd98350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 4.246.232.101
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 13, 2010, at 3:19 AM, Xiaotian Feng wrote:

> From 6c3a91091b2910c23908a9f9953efcf3df14e522 Mon Sep 17 00:00:00 2001
> From: Xiaotian Feng <dfeng@redhat.com>
> Date: Tue, 13 Jul 2010 11:02:41 +0800
> Subject: [PATCH 12/30] selinux: tag avc cache alloc as non-critical
> 
> Failing to allocate a cache entry will only harm performance not correctness.
> Do not consume valuable reserve pages for something like that.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> ---
> security/selinux/avc.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/security/selinux/avc.c b/security/selinux/avc.c
> index 3662b0f..9029395 100644
> --- a/security/selinux/avc.c
> +++ b/security/selinux/avc.c
> @@ -284,7 +284,7 @@ static struct avc_node *avc_alloc_node(void)
> {
> 	struct avc_node *node;
> 
> -	node = kmem_cache_zalloc(avc_node_cachep, GFP_ATOMIC);
> +	node = kmem_cache_zalloc(avc_node_cachep, GFP_ATOMIC|__GFP_NOMEMALLOC);
> 	if (!node)
> 		goto out;
> 
> -- 
> 1.7.1.1
> 

Why not just replace GFP_ATOMIC with GFP_NOWAIT?

This would NOT consume the valuable last pages.

Mitchell Erblich
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

