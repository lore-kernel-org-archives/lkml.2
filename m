Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab2KIPT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 10:19:58 -0500
Received: from zimbra.linbit.com ([212.69.161.123]:53401 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab2KIPTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 10:19:55 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] drbd-8.4.2 for the linux-3.8 merge window
Date: Fri, 09 Nov 2012 16:19:52 +0100
Message-ID: <15372058.EgEfohI4mf@fat-tyre>
User-Agent: KMail/4.8.5 (Linux/3.2.0-32-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <509D1830.8010103@kernel.dk>
References: <3042269.jrNem7z1LI@fat-tyre> <509D10A3.8040203@kernel.dk> <509D1830.8010103@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 9. November 2012, 15:50:24 schrieb Jens Axboe:
> On 2012-11-09 15:18, Jens Axboe wrote:
> > On 2012-11-09 14:33, Philipp Reisner wrote:
> >> Jens, here it is without the sysfs stuff
> > 
> > Thanks, pulled into for-3.8/drivers
> 
> I didn't say anything, but I've been fuming a bit the last few series of
> merge windows. You need to stop these insanely massive pull requests.
> I've been large since this is "just a driver", but it can't continue. We
> should have reached stability a long time ago. Your pull requests
> contain a shit load of items, are you guys paying per commit? Look at
> these:
> 
>       drbd: Request lookup code cleanup (1)
>       drbd: Request lookup code cleanup (2)
>       drbd: Request lookup code cleanup (3)
>       drbd: Request lookup code cleanup (4)
> 

We are living there in the belief that we should break up big
changes in review able chunks....

> or
> 
>       drbd: conn_send_cmd2(): Return 0 upon success and an error code
> otherwise drbd: _conn_send_cmd(): Return 0 upon success and an error code
> otherwise drbd: _drbd_send_cmd(): Return 0 upon success and an error code
> otherwise drbd: conn_send_cmd(): Return 0 upon success and an error code
> otherwise
> 

Function by function gets converted to the "return 0 upon success" call
semantics.
Do you prefer that all of that should be done in a single commit?

> along with FIFTY or so more of these. WTF is this?
> 
>       drbd: Converted helper functions for drbd_send() to tconn
>       drbd: Converted drbd_send() from mdev to tconn
>       drbd: Converted drbd_send_fp() from mdev to tconn
> 

Should it instead be in a single commit?

> 
> I don't think I need to go on. So from now on, to get items into the
> kernel, what you will do is:
> 
> - Stop doing insane commits like the above. It just doesn't make sense.
> 
> - Send pull requests in a timely fashion. No more of this "lets collect
>   ALL the things" then send it off. Collect small bug fixes, send those
>   off. Develop some feature or make some changes, send that off. Etc.

That works well for individual features, and we have been doing that
for the last two Years.

But at this time we changed the object model. In the old code we had
a single kind of DRBD-in-kernel-object: a resource
Now we have two kinds: resources and volumes.

8.3: a resource had a single implicit volume

8.4: a resource might contain multiple volumes, each volume belongs to
     a single resource.

In the next ~12 month you will get only small features/updates etc... for
the 8.4 code base.

> The fact that your initial pull request had to MASK all these commits
> should have rung big bells in your head. It's a clear sign of a huge
> problem in your development model. If you can't clean this up, then
> it's not going in.

Fundamental changes in our object model require such huge change sets.
Jens, we will not stop where we are today. We plan to introduce a new
object: a connection. (The ability to mirror for one machine to *multiple*
receivers.)

Is it a better fit to introduce it then as a new driver? 
E.g. called it "drbd9". 
Should it use a new major number?

Best,
 Phil
