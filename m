Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab2GQUtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 16:49:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56628 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab2GQUtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 16:49:16 -0400
Date: Tue, 17 Jul 2012 13:49:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <js1304@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Christoph Lameter <cl@linux.com>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] mm: fix wrong argument of migrate_huge_pages() in
 soft_offline_huge_page()
Message-Id: <20120717134915.76adf9bd.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1207171340420.9675@chino.kir.corp.google.com>
References: <1342544460-20095-1-git-send-email-js1304@gmail.com>
	<alpine.DEB.2.00.1207171340420.9675@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2012 13:42:23 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Wed, 18 Jul 2012, Joonsoo Kim wrote:
> 
> > Commit a6bc32b899223a877f595ef9ddc1e89ead5072b8 ('mm: compaction: introduce
> > sync-light migration for use by compaction') change declaration of
> > migrate_pages() and migrate_huge_pages().
> > But, it miss changing argument of migrate_huge_pages()
> > in soft_offline_huge_page(). In this case, we should call with MIGRATE_SYNC.
> > So change it.
> > 
> > Additionally, there is mismatch between type of argument and function
> > declaration for migrate_pages(). So fix this simple case, too.
> > 
> > Signed-off-by: Joonsoo Kim <js1304@gmail.com>
> 
> Acked-by: David Rientjes <rientjes@google.com>
> 
> Should be cc'd to stable for 3.3+.

Well, why?  I'm suspecting a switch from MIGRATE_SYNC_LIGHT to
MIGRATE_SYNC will have no discernable effect.  Unless it triggers hitherto
unknkown about deadlocks...

For a -stable backport we should have a description of the end-user
visible effects of the bug.  This changelog lacked such a description.

