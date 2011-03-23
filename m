Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197Ab1CWPwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:52:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48553 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752Ab1CWPwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:52:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=m3cbrAjnvQkDlKeHC/bkjsTHQWQ6RSzCtmXOkPCxHORrZBulQJjmriYz+P5K/RwogF
         rh1x1OuAXBgS5jeu5z/G7/RujeNtXTL9ThfsFlxq64+yL6eY44g3UtHPfCMohyKrDD5A
         C3SAX+7R/+s+0QHvgvDUT161WsPyPBN3viGh0=
Date: Wed, 23 Mar 2011 16:52:06 +0100
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] mutex: Apply adaptive spinning on mutex_trylock()
Message-ID: <20110323155206.GD12003@htj.dyndns.org>
References: <20110323153727.GB12003@htj.dyndns.org>
 <AANLkTik4iG+Ssb+JU3YRB4C11CEZeVozqoiz4rvezFLL@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTik4iG+Ssb+JU3YRB4C11CEZeVozqoiz4rvezFLL@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 08:48:01AM -0700, Linus Torvalds wrote:
> On Wed, Mar 23, 2011 at 8:37 AM, Tejun Heo <tj@kernel.org> wrote:
> >
> > Currently, mutex_trylock() doesn't use adaptive spinning.  It tries
> > just once.  I got curious whether using adaptive spinning on
> > mutex_trylock() would be beneficial and it seems so, at least for
> > btrfs anyway.
> 
> Hmm. Seems reasonable to me. The patch looks clean, although part of
> that is just the mutex_spin() cleanup that is independent of actually
> using it in trylock.

Oh, I have two split patches.  Posted the combined one for comments.

> So no objections from me.

Awesome.  Peter, what do you think?  Are there some other tests which
can be useful?

Thanks.

-- 
tejun
