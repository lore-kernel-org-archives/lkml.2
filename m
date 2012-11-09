Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab2KIOvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 09:51:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:33184 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab2KIOvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 09:51:04 -0500
Message-ID: <509D1830.8010103@kernel.dk>
Date: Fri, 09 Nov 2012 15:50:24 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Philipp Reisner <philipp.reisner@linbit.com>
CC: drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] drbd-8.4.2 for the linux-3.8 merge window
References: <3042269.jrNem7z1LI@fat-tyre> <4229483.8Hqs9YQUgX@fat-tyre> <509CFD70.5020807@kernel.dk> <1670685.HQRLhryL3A@fat-tyre> <509D10A3.8040203@kernel.dk>
In-Reply-To: <509D10A3.8040203@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-09 15:18, Jens Axboe wrote:
> On 2012-11-09 14:33, Philipp Reisner wrote:
>> Jens, here it is without the sysfs stuff
> 
> Thanks, pulled into for-3.8/drivers

I didn't say anything, but I've been fuming a bit the last few series of
merge windows. You need to stop these insanely massive pull requests.
I've been large since this is "just a driver", but it can't continue. We
should have reached stability a long time ago. Your pull requests
contain a shit load of items, are you guys paying per commit? Look at
these:

      drbd: Request lookup code cleanup (1)
      drbd: Request lookup code cleanup (2)
      drbd: Request lookup code cleanup (3)
      drbd: Request lookup code cleanup (4)

or

      drbd: conn_send_cmd2(): Return 0 upon success and an error code otherwise
      drbd: _conn_send_cmd(): Return 0 upon success and an error code otherwise
      drbd: _drbd_send_cmd(): Return 0 upon success and an error code otherwise
      drbd: conn_send_cmd(): Return 0 upon success and an error code otherwise

along with FIFTY or so more of these. WTF is this?

      drbd: Converted helper functions for drbd_send() to tconn
      drbd: Converted drbd_send() from mdev to tconn
      drbd: Converted drbd_send_fp() from mdev to tconn

...

I don't think I need to go on. So from now on, to get items into the
kernel, what you will do is:

- Stop doing insane commits like the above. It just doesn't make sense.

- Send pull requests in a timely fashion. No more of this "lets collect
  ALL the things" then send it off. Collect small bug fixes, send those
  off. Develop some feature or make some changes, send that off. Etc.

The fact that your initial pull request had to MASK all these commits
should have rung big bells in your head. It's a clear sign of a huge
problem in your development model. If you can't clean this up, then
it's not going in.

-- 
Jens Axboe

