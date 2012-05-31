Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab2EaVDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 17:03:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50797 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab2EaVDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 17:03:39 -0400
Date: Thu, 31 May 2012 23:03:35 +0200
From: Jan Kara <jack@suse.cz>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, tj@kernel.org,
        axboe@kernel.dk, paul.gortmaker@windriver.com,
        Daniel Santos <danielfsantos@att.net>
Subject: Re: [PATCH 0/3] Generic rb tree code
Message-ID: <20120531210335.GC16338@quack.suse.cz>
References: <1337979461-19654-1-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337979461-19654-1-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 25-05-12 13:57:38, Kent Overstreet wrote:
> Right now, users of the rb tree code have to open code their own search and
> insert functions. This provides generic versions that you pass a comparison
> function to.
> 
> I highly doubt the extra function calls are going to have a measurable
> performance impact in practice - the pointer chasing is going to dominate. I
> did provide inline versions just in case, though - it's modelled after the
> spinlock code.
> 
> The inline version of rb_search() is important for another reason, though - you
> have to pass rb_search a pointer to your struct for it to compare against,
> which has to be allocated on the stack. For most users I think that'll be fine,
> but for the elevator code struct rb_node is embedded in struct request, which
> is rather large. By using the inline version that stack allocation goes away.
> 
> (I looked at the generated assembly of elv_rb_find() before and after, and if
> I'm reading it right it's not using any extra stack. Code is a bit worse, but
> IMO removing code duplication is worth it).
> 
> Kent Overstreet (3):
>   rbtree: Add rb_insert(), rb_search(), etc.
>   timerqueue: convert to generic rb tree code
>   block: convert elevator to generic rb tree code
  Hum, are you aware of another generic rb-tree attempt -
 https://lkml.org/lkml/2012/4/30/132 ?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
