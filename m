Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab0HCM1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 08:27:10 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57436 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756010Ab0HCM1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 08:27:08 -0400
Message-ID: <4C580B1C.3020409@kernel.dk>
Date: Tue, 03 Aug 2010 14:27:08 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Artem Bityutskiy <dedekind1@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCHv6 00/15] kill unnecessary bdi wakeups + cleanups
References: <1280057365-10297-1-git-send-email-dedekind1@gmail.com>
In-Reply-To: <1280057365-10297-1-git-send-email-dedekind1@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-07-25 13:29, Artem Bityutskiy wrote:
> Hi,
> 
> here is v6 of the patch series which clean-ups bdi threads and substantially
> lessens amount of unnecessary kernel wake-ups, which is very important on
> battery-powered devices.
> 
> This patch-set is also available at:
> git://git.infradead.org/users/dedekind/misc-2.6.git flushers_v6

Thanks Artem, for sticking around long enough to get this into
shape. I have finally merged it.

> 1. Use 'spin_lock_bh' for the 'bdi->wb_lock' (changed patch N12)

I'd rather not, question is how to avoid it. Either just wakeup the
default thread, or punt the lock-and-check bdi->wb.task to a thread.

-- 
Jens Axboe

