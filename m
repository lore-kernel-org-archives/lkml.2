Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab0JAGMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 02:12:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60188 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab0JAGMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 02:12:17 -0400
Date: Fri, 1 Oct 2010 02:12:15 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: inode per-cpu last_ino allocator
Message-ID: <20101001061215.GJ32349@infradead.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-16-git-send-email-david@fromorbit.com>
 <20100929215312.5fcb6976.akpm@linux-foundation.org>
 <1285824982.5211.675.camel@edumazet-laptop>
 <1285833189.2615.31.camel@edumazet-laptop>
 <20100930011417.6ca16ed7.akpm@linux-foundation.org>
 <1285842136.2615.251.camel@edumazet-laptop>
 <20100930094558.97c9afa2.akpm@linux-foundation.org>
 <1285867685.2615.865.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285867685.2615.865.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

what workload did this matter for?  As mentioned elsewhere we don't
actually need to set i_ino in new_inode in many cases.  Normal
disk/network filesystem already set their own i_ino anyway and don't
need it at all.  Various in-kernel filesystems don't need any valid
i_ino and Nick's full series actually has a patch dealing with it,
which only leaves various user-mountable syntetic filesystems that
want to generate an inode number, and IMHO they're better off using
iunique.

