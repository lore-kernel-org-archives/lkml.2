Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab0HKNLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 09:11:45 -0400
Received: from mailbigip.dreamhost.com ([208.97.132.5]:35557 "EHLO
	homiemail-a1.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752581Ab0HKNLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 09:11:43 -0400
Subject: Re: [PATCH] jbd: Remove redundant NULL check upon kfree()
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.00.1008111505420.2372@twin.jikos.cz>
References: <1281531654.2067.2.camel@cowboy>
	 <alpine.LRH.2.00.1008111505420.2372@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 09:11:37 -0400
Message-ID: <1281532297.2067.8.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-11 at 15:06 +0200, Jiri Kosina wrote:
> On Wed, 11 Aug 2010, Davidlohr Bueso wrote:
> 
> > jbd: Remove redundant NULL check upon kfree().
> > 
> > Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> > ---
> >  fs/jbd/transaction.c |    3 +--
> >  1 files changed, 1 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
> > index 5ae71e7..5e98130 100644
> > --- a/fs/jbd/transaction.c
> > +++ b/fs/jbd/transaction.c
> > @@ -232,8 +232,7 @@ repeat_locked:
> >  
> >  	lock_map_acquire(&handle->h_lockdep_map);
> >  out:
> > -	if (unlikely(new_transaction))		/* It's usually NULL */
> > -		kfree(new_transaction);
> > +	kfree(new_transaction);
> 
> This doesn't seem entirely redundant, as it is optimized (via the 
> unlikely() hint) for the opposite case than what kfree() is optimized for 
> (kfree() assumes that the pointer is likely non-NULL, while the code above 
> assumes that the pointer si likely NULL).
> 

Ok, makes sense. I was a bit doubtful about the unlikely(), thanks for
the review.

Davidlohr

