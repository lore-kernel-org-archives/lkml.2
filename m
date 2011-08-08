Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab1HHNCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 09:02:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38497 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab1HHNCj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 09:02:39 -0400
Subject: Re: [PATCH 2/2] dentry: move to per-sb LRU locks
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Date: Mon, 08 Aug 2011 15:02:24 +0200
In-Reply-To: <1312787021-11324-3-git-send-email-david@fromorbit.com>
References: <1312787021-11324-1-git-send-email-david@fromorbit.com>
	 <1312787021-11324-3-git-send-email-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312808544.10488.31.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-08 at 17:03 +1000, Dave Chinner wrote:
> +       /* s_dentry_lru_lock protects s_dentry_lru, s_nr_dentry_unused */
> +       spinlock_t              s_dentry_lru_lock ____cacheline_aligned_in_smp;
>         struct list_head        s_dentry_lru;   /* unused dentry lru */ 

Wouldn't it make sense to have both those on the same cacheline?
