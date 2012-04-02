Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab2DBJt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 05:49:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:53289 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485Ab2DBJt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 05:49:28 -0400
Message-ID: <1333360116.30734.50.camel@pasglop>
Subject: Re: broken nouveau dependency on power supply
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Airlie <airlied@redhat.com>
Cc: Anton Vorontsov <cbou@mail.ru>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Woodhouse <dwmw2@infradead.org>, dri-devel@lists.freedesktop.org,
        David@freedesktop.org, linux-kernel@vger.kernel.org
Date: Mon, 02 Apr 2012 19:48:36 +1000
In-Reply-To: <6373b480-2185-4651-b12d-8498c806ff69@zmail16.collab.prod.int.phx2.redhat.com>
References: <6373b480-2185-4651-b12d-8498c806ff69@zmail16.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-02 at 05:00 -0400, David Airlie wrote:
> >  - Better: Just make the bloody thing a bool :-) The power supply
> > framework itself is small enough, just make it a boolean option and
> > avoid the problem entirely. The actual power supply sub drivers can
> > remain modular of course.
> 
> We can just do select POWER_SUPPLY.

Well, select'ing otherwise user configurable options was still frowned
on last we discussed that... and it makes the whole inline stubs in
power_supply.h totally pointless :-)

> Yes it reduces the option range for some stupid corner case but really
> I don't care, removing features from the kernel that a driver depends
> on is just leading to insane state combination and QA problems.

Well, the power supply stuff only works if you have a backend for it,
which not all platforms are, and it's fairly safe to assume AC whenever
it's not actually supported.

(Talking of which, we should be able to do a PowerBook backend
reasonably easily).

I don't care which solution you guys end up choosing though, just fix
it :-)

Cheers,
Ben.


