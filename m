Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab0IPCRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 22:17:50 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:49297 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab0IPCRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 22:17:49 -0400
Date: Thu, 16 Sep 2010 11:47:43 +0930
From: Christopher Yeoh <cyeoh@au1.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Cross Memory Attach
Message-ID: <20100916114743.5dcd228d@lilo>
In-Reply-To: <10951.1284566831@localhost>
References: <20100915104855.41de3ebf@lilo>
	<10951.1284566831@localhost>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010 12:07:11 -0400
Valdis.Kletnieks@vt.edu wrote:
> 
> Interesting, and nice benchmark results.  I have a question though:
> 
> > +	/* Get the pages we're interested in */
> > +	pages_pinned = get_user_pages(task, task->mm, pa,
> > +				      nr_pages_to_copy,
> > +				      copy_to, 0, process_pages,
> > NULL); +
> > +	if (pages_pinned != nr_pages_to_copy)
> > +		goto end;
> 
> ...
> 
> > +end:
> > +	for (i = 0; i < pages_pinned; i++) {
> > +		if (copy_to)
> > +			set_page_dirty_lock(process_pages[i]);
> > +		put_page(process_pages[i]);
> > +	}
> 
> It looks to me like if get_user_pages() fails to pin *all* the pages,
> we treat the target pages as dirty even though we never actually
> touched them?
> 
> Maybe it should be 'if (copy_to && *bytes_copied)'?

Yes that can happen, though the *bytes_copied check doesn't completely
fix it as copy_from_user could fail resulting in some pages being
touched, but not all of them.  I'll add some code to only call
set_page_dirty_lock on pages that really have been touched...

Regards,

Chris
-- 
cyeoh@au.ibm.com
