Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab1A1XL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 18:11:56 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42086 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab1A1XLz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 18:11:55 -0500
MIME-Version: 1.0
X-Originating-IP: [95.166.159.124]
In-Reply-To: <20110128211825.GA20707@mail.hallyn.com>
References: <AANLkTimP=5A-BNHUwV0qhvjw8y4HevMvXtOBpRr6vFYR@mail.gmail.com>
	<20110128211825.GA20707@mail.hallyn.com>
Date: Sat, 29 Jan 2011 00:11:53 +0100
Message-ID: <AANLkTi=1ubso_qg1dr+xOaF4s=f0Jfzchinh3dnY7jjY@mail.gmail.com>
Subject: Re: nbd locking problems
From: Soren Hansen <soren@linux2go.dk>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/28 Serge E. Hallyn <serge@hallyn.com>:
> Thanks for looking into this, Soren.

Sure :)

> As Dave just explained to me, BKL is released when you sleep :)

Ah, yes, that makes perfect sense.

> I assume that's how it gets released around the kthread_create().  I
> *think* you're right that the new mutex is superfluous, but I'd like to
> look through the ioctl code and make sure there's no shared state which
> we need to protect.

Yup, I've tried that and I didn't find anything, but this is very new
territory to me, so more eyes sounds great.

> I don't see how there could be, or rather, if there
> were, then it was broken before.

Good point.

> In the meantime, could you please post your patch?  (Is it the
> three-liner I'd expect?)

Indeed it is. I was holding off on posting it, because I was hoping
Pavel Machek would chime in. Pavel's commit message in [1] suggested
that there was more work to do before the BKL could be vanquished from
this driver (by changing .ioctl to .unlocked_ioctl).

I guess it can't hurt to post it, though. I'll do that in a second.

[1]: 1a2ad21128bb4eb79f3c05e5801edcc5ed3ef1d3

-- 
Soren Hansen        | http://linux2go.dk/
Ubuntu Developer    | http://www.ubuntu.com/
OpenStack Developer | http://www.openstack.org/
