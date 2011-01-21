Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab1AUNYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 08:24:01 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55119 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927Ab1AUNYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 08:24:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZXthHo9RXszgTVZD9w4IGWCsoqAiBS0lAP0LlL8gd+f6f8OykbZuWmP/HtjBQW9Pl6
         pmpMaFFT0U6HM7XxAlhO1KYhAOdgIAAKjBsklRWOeUNbAajIqDStJ4hlQDCx1zzHz/xB
         oHXtMiv6e9Q9OYRjlPWEslAV5CWli6SgFSHAc=
Date: Fri, 21 Jan 2011 21:23:49 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Torben Hohn <torbenh@gmx.de>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@tglx.de>
Subject: Re: [PATCH] RFC: abstract access to xtime_lock into a set of
 inline functions
Message-ID: <20110121132349.GB6051@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1295543648-13788-1-git-send-email-torbenh@gmx.de>
 <20110120173029.GA26121@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110120173029.GA26121@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 12:30:29PM -0500, Christoph Hellwig wrote:
> On Thu, Jan 20, 2011 at 06:14:08PM +0100, Torben Hohn wrote:
> > the -rt patches change the xtime_lock to a raw_seqlock_t
> > so a pretty huge portion of the patch deals with changing
> > the locking functions.
> > 
> > this commit uses inline functions, to hide the type
> > of the lock.
> 
> That's not how kernel code usually works.
> 
> > -	write_seqlock(&xtime_lock);
> > +	xtime_write_seqlock();
> >  	do_timer(1);
> > -	write_sequnlock(&xtime_lock);
> > +	xtime_write_sequnlock();
> 
> However there's a pretty clear pattern of taking xtime_lock, calling
> do_timer and then releasing.  A useful thing you could do is to rename
> do_timer to do_timer_locked and make do_timer take and release
> xtime_lock in one place.

How about adding raw_seqlock just like what we have done for
spinlock? Thus xtime_lock can be defined to raw_seqlock and
others can also benefit from the raw_seqlock like xtime_lock.

Thanks,
Yong
