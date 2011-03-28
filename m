Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab1C1IX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 04:23:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64354 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab1C1IX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 04:23:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SfbW/3axkk40UKEBzwpDng29a9bxNGAj51ei1Q5ghpGQvitOXjZg7G2Khw0LnabN3r
         oPz7t6EZFNVszUHvSnTBhGaZ6k/sFnWVTT3OT/M2jQfps87sHRbdfcrzRJNe9nG1CR41
         K7FhqaJD6FxxaU18cgvjjMfejfrktgaLIBdRo=
Date: Mon, 28 Mar 2011 10:23:21 +0200
From: Tejun Heo <tj@kernel.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
        Vivek Goyal <vgoyal@redhat.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: elevator private data for REQ_FLUSH
Message-ID: <20110328082321.GC16530@htj.dyndns.org>
References: <20110325151530.GA4414@swordfish.minsk.epam.com>
 <20110325152228.GA1707@gentoo.trippels.de>
 <20110325154024.GA16029@redhat.com>
 <4D8CB9C9.5010208@kernel.dk>
 <20110325185455.GA2969@redhat.com>
 <4D8CF202.9010809@kernel.dk>
 <20110326042156.GB28458@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110326042156.GB28458@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Sat, Mar 26, 2011 at 12:21:56AM -0400, Mike Snitzer wrote:
> > Yes, I was thinking about something like that. I consider the patch
> > merged an immediate stop gap, we need to improve this situation. It's
> > not exactly pretty to have this sort of condition in both
> > __make_request() and flush_plug_list(). Clearly it should be handled
> > further down.
> 
> OK, and btw my patch was too restrictive.  blk_kick_flush()
> elv_insert()s a flush request with ELEVATOR_INSERT_REQUEUE.
> 
> Should blk_kick_flush() process the flush request without calling
> elv_insert() -- like is done with open coded list_add() in
> blk_insert_flush()?
> 
> Or should blk_insert_flush() use elv_insert() with
> ELEVATOR_INSERT_REQUEUE too? 

Hmmm... I would prefer the latter.  Given that INSERT_REQUEUE and
FRONT are no longer different, it would probably be better to use
FRONT tho.  The only reason REQUEUE is used there is to avoid kicking
the queue from elv_insert(), which is gone now.

Thanks.

-- 
tejun
