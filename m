Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab1A1BsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 20:48:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753863Ab1A1BsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 20:48:11 -0500
Date: Thu, 27 Jan 2011 17:48:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sunil Mushran <sunil.mushran@oracle.com>
Cc: dsterba@suse.cz, mfasheh@suse.com, linux-kernel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] fs/ocfs2/dlm: Use GFP_ATOMIC under spin_lock
Message-Id: <20110127174801.c22d693b.akpm@linux-foundation.org>
In-Reply-To: <4D421BD5.30903@oracle.com>
References: <20101102223601.GA27513@ds.suse.cz>
	<20110127170948.9a0d8b60.akpm@linux-foundation.org>
	<4D421BD5.30903@oracle.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011 17:28:53 -0800 Sunil Mushran <sunil.mushran@oracle.com> wrote:

> >   	return status;
> >   }
> >
> > @@ -1077,6 +1069,7 @@ static int dlm_query_region_handler(stru
> >   	struct dlm_ctxt *dlm = NULL;
> >   	int status = 0;
> >   	int locked = 0;
> > +	static u8 local[sizeof(qr->qr_regions)]; /* locked by dlm_domain_lock */
> >
> >   	qr = (struct dlm_query_region *) msg->buf;
> >
> > @@ -1112,7 +1105,7 @@ static int dlm_query_region_handler(stru
> >   		goto bail;
> >   	}
> >
> > -	status = dlm_match_regions(dlm, qr);
> > +	status = dlm_match_regions(dlm, qr, local);
> >
> >   bail:
> >   	if (locked)
> 
> That sizeof() is 1K. It maybe better if we moved the kmalloc() here.

That would work too.  As it's only called at mount time, the
speed/space tradeoff favours kmalloc().

