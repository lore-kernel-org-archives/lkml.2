Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760002Ab0HEJhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 05:37:32 -0400
Received: from smtp.nokia.com ([192.100.122.233]:49579 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759509Ab0HEJh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 05:37:29 -0400
Subject: Re: [PATCHv6 00/15] kill unnecessary bdi wakeups + cleanups
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <4C595037.4050408@fusionio.com>
References: <1280057365-10297-1-git-send-email-dedekind1@gmail.com>
	 <4C580B1C.3020409@kernel.dk> <1280839036.15689.8.camel@localhost>
	 <4C580FFF.2000605@kernel.dk>  <4C595037.4050408@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 12:35:47 +0300
Message-ID: <1281000947.15689.77.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 Aug 2010 09:37:01.0722 (UTC) FILETIME=[C1CF87A0:01CB3481]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 13:34 +0200, Jens Axboe wrote:
> On 2010-08-03 14:47, Jens Axboe wrote:
> > On 2010-08-03 14:37, Artem Bityutskiy wrote:
> >> On Tue, 2010-08-03 at 14:27 +0200, Jens Axboe wrote:
> >>> On 2010-07-25 13:29, Artem Bityutskiy wrote:
> >>>> Hi,
> >>>>
> >>>> here is v6 of the patch series which clean-ups bdi threads and substantially
> >>>> lessens amount of unnecessary kernel wake-ups, which is very important on
> >>>> battery-powered devices.
> >>>>
> >>>> This patch-set is also available at:
> >>>> git://git.infradead.org/users/dedekind/misc-2.6.git flushers_v6
> >>>
> >>> Thanks Artem, for sticking around long enough to get this into
> >>> shape. I have finally merged it.
> >>
> >> Thanks, but
> >>
> >>>> 1. Use 'spin_lock_bh' for the 'bdi->wb_lock' (changed patch N12)
> >>>
> >>> I'd rather not, question is how to avoid it. Either just wakeup the
> >>> default thread, or punt the lock-and-check bdi->wb.task to a thread.
> >>
> >> you merged this change, do you want me to send a separate patch which
> >> undo the 'spin_lock_bh' change? I'll think about how to avoid this and
> >> come back.
> > 
> > Yes, it's not a huge thing, but it would be nice to get rid of. So I
> > figured it was better to merge it and not have you respin the series yet
> > again.
> 
> There is a spinlock bug in the current code, you nest _bh locks on lock
> but not always on unlock. I fixed it up as per the below:

Right, sorry, to be frank I never used _bh spinlock versions before, and
just did not know the nesting trick. Thanks for fixing.

Also, I'm still not sure whether I should get rid of this _bh or not. I
wrote my thoughts to you in another e-mail.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

