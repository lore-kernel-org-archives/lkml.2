Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab0HCMiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 08:38:25 -0400
Received: from smtp.nokia.com ([192.100.105.134]:65476 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab0HCMiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 08:38:24 -0400
Subject: Re: [PATCHv6 00/15] kill unnecessary bdi wakeups + cleanups
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <4C580B1C.3020409@kernel.dk>
References: <1280057365-10297-1-git-send-email-dedekind1@gmail.com>
	 <4C580B1C.3020409@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Aug 2010 15:37:16 +0300
Message-ID: <1280839036.15689.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Aug 2010 12:38:10.0587 (UTC) FILETIME=[BB5536B0:01CB3308]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-03 at 14:27 +0200, Jens Axboe wrote:
> On 2010-07-25 13:29, Artem Bityutskiy wrote:
> > Hi,
> > 
> > here is v6 of the patch series which clean-ups bdi threads and substantially
> > lessens amount of unnecessary kernel wake-ups, which is very important on
> > battery-powered devices.
> > 
> > This patch-set is also available at:
> > git://git.infradead.org/users/dedekind/misc-2.6.git flushers_v6
> 
> Thanks Artem, for sticking around long enough to get this into
> shape. I have finally merged it.

Thanks, but

> > 1. Use 'spin_lock_bh' for the 'bdi->wb_lock' (changed patch N12)
> 
> I'd rather not, question is how to avoid it. Either just wakeup the
> default thread, or punt the lock-and-check bdi->wb.task to a thread.

you merged this change, do you want me to send a separate patch which
undo the 'spin_lock_bh' change? I'll think about how to avoid this and
come back.


-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

