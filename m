Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab0H3NC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 09:02:58 -0400
Received: from borg.medozas.de ([188.40.89.202]:55077 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082Ab0H3NC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 09:02:57 -0400
Date: Mon, 30 Aug 2010 15:02:55 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Andreas Gruenbacher <agruen@suse.de>
cc: David Miller <davem@davemloft.net>, netfilter@vger.kernel.org,
        eparis@redhat.com, linux-kernel@vger.kernel.org, schwab@redhat.com,
        Harald Welte <laforge@netfilter.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: aligned_{u64,be64,le64} defined in #ifdef __KERNEL__
In-Reply-To: <201008301258.33113.agruen@suse.de>
Message-ID: <alpine.LNX.2.01.1008301502280.19931@obet.zrqbmnf.qr>
References: <1282682582-15980-1-git-send-email-eparis@redhat.com> <201008300326.30233.agruen@suse.de> <20100829.212156.229740543.davem@davemloft.net> <201008301258.33113.agruen@suse.de>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2010-08-30 12:58, Andreas Gruenbacher wrote:
>
>> If we want a version of this type visible to userspace, it needs to,
>> for example, have double underscores prepended to the type name just
>> as we do for things like __u16 and __u32.
>
>How about something like this?


I like that approach:

>From 3bec018a4835d4fdbe35595366a51bd09e3cc1d0 Mon Sep 17 00:00:00 2001
>From: Andreas Gruenbacher <agruen@suse.de>
>Date: Mon, 30 Aug 2010 12:51:01 +0200
>Subject: [PATCH] Define __aligned_{u64,le64,be64} types with 8-byte alignment
>
>Convert the existing #defines into typedefs, prepend two underscores to
>avoid POSIX namespace pollution, and expose the types to user space.
>
>These types are useful for enforcing the same alignment on 32-bit and
>64-bit architectures.  (Some 32-bit architectures only align 64-bit
>values on 4-byte boundaries by default.)
>
>(The aligned types are used by some netfilter user-space headers
>already.)
>
>Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
>---
> include/linux/if_ppp.h                    |   16 +++++++-------
> include/linux/netfilter/nfnetlink_log.h   |    4 +-
> include/linux/netfilter/nfnetlink_queue.h |    4 +-
> include/linux/netfilter/xt_connbytes.h    |    4 +-
> include/linux/netfilter/xt_quota.h        |    2 +-
> include/linux/types.h                     |   10 ++++----
> include/scsi/scsi_tgt_if.h                |   30 ++++++++++++++--------------
> include/xen/interface/hvm/hvm_op.h        |    2 +-
> 8 files changed, 36 insertions(+), 36 deletions(-)
>
>diff --git a/include/linux/if_ppp.h b/include/linux/if_ppp.h
>index fcef103..c9ad383 100644
>--- a/include/linux/if_ppp.h
>+++ b/include/linux/if_ppp.h
>@@ -114,14 +114,14 @@ struct pppol2tp_ioc_stats {
> 	__u16		tunnel_id;	/* redundant */
> 	__u16		session_id;	/* if zero, get tunnel stats */
> 	__u32		using_ipsec:1;	/* valid only for session_id == 0 */
>-	aligned_u64	tx_packets;
>-	aligned_u64	tx_bytes;
>-	aligned_u64	tx_errors;
>-	aligned_u64	rx_packets;
>-	aligned_u64	rx_bytes;
>-	aligned_u64	rx_seq_discards;
>-	aligned_u64	rx_oos_packets;
>-	aligned_u64	rx_errors;
>+	__aligned_u64	tx_packets;
>+	__aligned_u64	tx_bytes;
>+	__aligned_u64	tx_errors;
>+	__aligned_u64	rx_packets;
>+	__aligned_u64	rx_bytes;
>+	__aligned_u64	rx_seq_discards;
>+	__aligned_u64	rx_oos_packets;
>+	__aligned_u64	rx_errors;
