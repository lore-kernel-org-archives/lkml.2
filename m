Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab2JCPBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:01:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956Ab2JCPBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:01:23 -0400
Date: Wed, 3 Oct 2012 17:01:17 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lukas@localhost
To: Jeff Moyer <jmoyer@redhat.com>
cc: Dave Chinner <dchinner@redhat.com>,
        =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] loop: Limit the number of requests in the bio list
In-Reply-To: <x49txubvd9d.fsf@segfault.boston.devel.redhat.com>
Message-ID: <alpine.LFD.2.00.1210031659480.18540@localhost>
References: <1348767205-17230-1-git-send-email-lczerner@redhat.com> <x49ipaukud8.fsf@segfault.boston.devel.redhat.com> <alpine.LFD.2.00.1210021042580.21903@localhost> <20121002195934.GA2657@devil.redhat.com>
 <x49txubvd9d.fsf@segfault.boston.devel.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571107329-122787644-1349276481=:18540"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571107329-122787644-1349276481=:18540
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 3 Oct 2012, Jeff Moyer wrote:

> Date: Wed, 03 Oct 2012 10:30:54 -0400
> From: Jeff Moyer <jmoyer@redhat.com>
> To: Dave Chinner <dchinner@redhat.com>
> Cc: Lukáš Czerner <lczerner@redhat.com>, Jens Axboe <axboe@kernel.dk>,
>     linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] loop: Limit the number of requests in the bio list
> 
> Dave Chinner <dchinner@redhat.com> writes:
> 
> > On Tue, Oct 02, 2012 at 10:52:05AM +0200, Lukáš Czerner wrote:
> >> On Mon, 1 Oct 2012, Jeff Moyer wrote:
> >> > Date: Mon, 01 Oct 2012 12:52:19 -0400
> >> > From: Jeff Moyer <jmoyer@redhat.com>
> >> > To: Lukas Czerner <lczerner@redhat.com>
> >> > Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
> >> >     Dave Chinner <dchinner@redhat.com>
> >> > Subject: Re: [PATCH] loop: Limit the number of requests in the bio list
> >> > 
> >> > Lukas Czerner <lczerner@redhat.com> writes:
> >> > 
> >> > > Currently there is not limitation of number of requests in the loop bio
> >> > > list. This can lead into some nasty situations when the caller spawns
> >> > > tons of bio requests taking huge amount of memory. This is even more
> >> > > obvious with discard where blkdev_issue_discard() will submit all bios
> >> > > for the range and wait for them to finish afterwards. On really big loop
> >> > > devices this can lead to OOM situation as reported by Dave Chinner.
> >> > >
> >> > > With this patch we will wait in loop_make_request() if the number of
> >> > > bios in the loop bio list would exceed 'nr_requests' number of requests.
> >> > > We'll wake up the process as we process the bios form the list.
> >> > 
> >> > I think you might want to do something similar to what is done for
> >> > request_queues by implementing a congestion on and off threshold.  As
> >> > Jens writes in this commit (predating the conversion to git):
> >> 
> >> Right, I've had the same idea. However my first proof-of-concept
> >> worked quite well without this and my simple performance testing did
> >> not show any regression.
> 
> Did you look at system time?
> 
> -Jeff

Hi, none of the times showed any significant difference, there was
not any pattern suggesting a problem. Also the system time is included
in the real time, so it would show anyway I guess.

-Lukas
--571107329-122787644-1349276481=:18540--
