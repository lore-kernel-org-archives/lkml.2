Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab0FNR1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 13:27:22 -0400
Received: from thunk.org ([69.25.196.29]:44573 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756487Ab0FNR1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 13:27:21 -0400
Date: Mon, 14 Jun 2010 13:27:18 -0400
From: tytso@mit.edu
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [17/23] EXT3: Fix set but unused variables
Message-ID: <20100614172718.GC6666@thunk.org>
Mail-Followup-To: tytso@mit.edu, Andi Kleen <andi@firstfloor.org>,
	linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20100610110.764742110@firstfloor.org>
 <20100610111053.43E78B1A2B@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100610111053.43E78B1A2B@basil.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 01:10:53PM +0200, Andi Kleen wrote:
> Index: linux-2.6.35-rc2-gcc/fs/jbd/recovery.c
> ===================================================================
> --- linux-2.6.35-rc2-gcc.orig/fs/jbd/recovery.c
> +++ linux-2.6.35-rc2-gcc/fs/jbd/recovery.c
> @@ -283,12 +283,10 @@ int journal_recover(journal_t *journal)
>  int journal_skip_recovery(journal_t *journal)
>  {
>  	int			err;
> -	journal_superblock_t *	sb;
>  
>  	struct recovery_info	info;
>  
>  	memset (&info, 0, sizeof(info));
> -	sb = journal->j_superblock;

Oops, spoke too soon.  This will cause a compile error if
CONFIG_JBD_DEBUG is defined.

The following pesudo-patch is required:

 #ifdef CONFIG_JBD_DEBUG
-		int dropped = info.end_transaction - be32_to_cpu(sb->s_sequence);
+		int dropped = info.end_transaction - 
+				be32_to_cpu(journal->j_superblock->s_sequence);
 #endif

						- Ted

