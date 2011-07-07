Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab1GGQql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 12:46:41 -0400
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:2239 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab1GGQqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 12:46:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC PATCH] poll: add poll_requested_events() function
Date: Thu, 7 Jul 2011 18:46:33 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc7-durdane; KDE/4.4.5; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-media" <linux-media@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
References: <201107011537.30829.hverkuil@xs4all.nl> <20110707104255.6771771d@bike.lwn.net>
In-Reply-To: <20110707104255.6771771d@bike.lwn.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107071846.33586.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 07, 2011 18:42:55 Jonathan Corbet wrote:
> On Fri, 1 Jul 2011 15:37:30 +0200
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
> > In some cases the poll() implementation in a driver has to do different
> > things depending on the events the caller wants to poll for. An example is
> > when a driver needs to start a DMA engine if the caller polls for POLLIN,
> > but doesn't want to do that if POLLIN is not requested but instead only
> > POLLOUT or POLLPRI is requested. This is something that can happen in the
> > video4linux subsystem.
> 
> The change makes sense to me, FWIW.  One bit of trivia I noticed while
> looking at it:
> 
> > @@ -796,7 +792,7 @@ static int do_poll(unsigned int nfds,  struct poll_list *list,
> >  		 * All waiters have already been registered, so don't provide
> >  		 * a poll_table to them on the next loop iteration.
> >  		 */
> > -		pt = NULL;
> > +		pt->qproc = NULL;
> >  		if (!count) {
> >  			count = wait->error;
> >  			if (signal_pending(current))
> 
> The comment at the beginning of this hunk is no longer accurate since the
> poll_table is, indeed, still being supplied.  The previous comment in the
> same function:
> 
> 				/*
> 				 * Fish for events. If we found one, record it
> 				 * and kill the poll_table, so we don't
> 				 * needlessly register any other waiters after
> 				 * this. They'll get immediately deregistered
> 				 * when we break out and return.
> 				 */
> 
> Could also use tweaking.

Indeed! I'll make an RFCv3 tomorrow fixing this.

Thanks for looking at this!

Regards,

	Hans
