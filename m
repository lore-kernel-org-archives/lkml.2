Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab1A1BtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 20:49:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753863Ab1A1BtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 20:49:08 -0500
Date: Thu, 27 Jan 2011 17:48:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joel Becker <jlbec@evilplan.org>
Cc: dsterba@suse.cz, mfasheh@suse.com, linux-kernel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] fs/ocfs2/dlm: Use GFP_ATOMIC under spin_lock
Message-Id: <20110127174857.1f49cefc.akpm@linux-foundation.org>
In-Reply-To: <20110128013552.GB8019@noexit>
References: <20101102223601.GA27513@ds.suse.cz>
	<20110127170948.9a0d8b60.akpm@linux-foundation.org>
	<20110128013552.GB8019@noexit>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011 17:35:53 -0800 Joel Becker <jlbec@evilplan.org> wrote:

> > --- a/fs/ocfs2/dlm/dlmdomain.c~a
> > +++ a/fs/ocfs2/dlm/dlmdomain.c
> > @@ -926,9 +926,9 @@ static int dlm_assert_joined_handler(str
> >  }
> >  
> >  static int dlm_match_regions(struct dlm_ctxt *dlm,
> > -			     struct dlm_query_region *qr)
> > +			     struct dlm_query_region *qr, u8 *local)
> >  {
> > -	char *local = NULL, *remote = qr->qr_regions;
> > +	char *remote = qr->qr_regions;
> 
> 	Won't the stack-depth busybodies hate us for this?  I realize we
> don't go much deeper from here, but it still is 1K of stack.

+	static u8 local[sizeof(qr->qr_regions)]; /* locked by dlm_domain_lock */
        ^^^^^^
