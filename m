Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972Ab0GXGI2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 02:08:28 -0400
Received: from smtp.nokia.com ([192.100.105.134]:35462 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab0GXGI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 02:08:27 -0400
Subject: Re: [PATCHv4 12/14] writeback: optimize periodic bdi thread wakeups
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100723162800.GB29633@infradead.org>
References: <1279897554-1526-1-git-send-email-dedekind1@gmail.com>
	 <1279897554-1526-13-git-send-email-dedekind1@gmail.com>
	 <20100723162800.GB29633@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 24 Jul 2010 09:00:08 +0300
Message-ID: <1279951208.4655.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 24 Jul 2010 06:07:17.0449 (UTC) FILETIME=[780ADB90:01CB2AF6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-23 at 12:28 -0400, Christoph Hellwig wrote:
> I haven't reviewed this in detail, but what ensures the timer is
> synchronously removed when the forker goes away?

Good point, thanks.

>   I don't see a
> del_timer_sync call anywhere.  For now it might be easier to just
> skip this patch and leave it for later.

Well, my tests showed that with this patch the flushers wake up
considerably less. So I'll try to come up with a better patch.

I will set-up better testing. Will hack things so that the background
dirty writeout timeout is something like 1-3 jiffies and the bdi thread
inactive timeout is something like 3-5 jiffies. Then will write a script
which forks many tasks each of each creates a loop-back device, mounts
it, does some I/O, unmounts, removes the loop-back device, and so on. If
run for long time, it should give good stress to the code paths I'm
working on. I have a 2-way 4-core (total 8) amd64 testbox to test.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

