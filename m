Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933753Ab0EUQAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:00:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:49378 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933711Ab0EUQAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:00:22 -0400
Date: Fri, 21 May 2010 18:00:14 +0200
From: Jan Kara <jack@suse.cz>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Zan Lynx <zlynx@acm.org>, lwoodman@redhat.com,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Nick Piggin <npiggin@suse.de>, Jan Kara <jack@suse.cz>
Subject: Re: RFC: dirty_ratio back to 40%
Message-ID: <20100521160014.GC3412@quack.suse.cz>
References: <20100521083408.1E36.A69D9226@jp.fujitsu.com>
 <4BF5D875.3030900@acm.org>
 <20100521100943.1E4D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100521100943.1E4D.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 21-05-10 10:11:59, KOSAKI Motohiro wrote:
> > > So, I'd prefer to restore the default rather than both Redhat and SUSE apply exactly
> > > same distro specific patch. because we can easily imazine other users will face the same
> > > issue in the future.
> > 
> > On desktop systems the low dirty limits help maintain interactive feel. 
> > Users expect applications that are saving data to be slow. They do not 
> > like it when every application in the system randomly comes to a halt 
> > because of one program stuffing data up to the dirty limit.
> 
> really?
> Do you mean our per-task dirty limit wouldn't works?
> 
> If so, I think we need fix it. IOW sane per-task dirty limitation seems
> independent issue from per-system dirty limit.
  Well, I don't know about any per-task dirty limits. What function
implements them? Any application that dirties a single page can be caught
and forced to call balance_dirty_pages() and do writeback.
  But generally what we observe on a desktop with lots of dirty memory is
that application needs to allocate memory (either private one or for page
cache) and that triggers direct reclaim so the allocation takes a long
time to finish and thus the application is sluggish...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
