Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab0HBCu1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 22:50:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751840Ab0HBCu0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 22:50:26 -0400
MIME-Version: 1.0
In-Reply-To: <20100802023322.GA19164@dastard>
References: <AANLkTim8FALeVG+NPLNLEQChu=dPD=GHSpnxmZHYgsNx@mail.gmail.com> 
	<20100802023322.GA19164@dastard>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 1 Aug 2010 19:50:02 -0700
Message-ID: <AANLkTint_s6h_EC7mDiPsyxr=C0GSrnrgJYkCCU7JEtN@mail.gmail.com>
Subject: Re: Linux 2.6.35
To: Dave Chinner <david@fromorbit.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 1, 2010 at 7:33 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> There hasn't been nearly enough review or testing of this patch
> series yet.  Before a merge, it needs to be split up in smaller,
> more digestable chunks for more comprehensive review, regression
> testing and behavioural analysis.

I dunno. We merge _way_ scarier things in the VM and the block layer,
for much less actual upside, and with less review.

The RCU pathname lookup has some rather impressive performance
upsides, and I agree that it would be good to get a lot of review and
testing, but the latter isn't going to happen without it being
mainlined, and the former is sadly lacking. The person I'd like most
to review it is Al, but anybody in the filesystem world should
basically see it as a #1 priority, because unlike all the masturbatory
patches like xstat() that add new functionality that nobody will
likely ever use, Nick's patchseries improves on the thing that
everybody uses heavily every day without even thinking about it.

Is it tough to review? Yes. It's core code, not just some random
addition that adds a new feature and doesn't impact any old code. But
that's also the thing that makes it meaningful, and makes me think it
should get merged _much_ more eagerly than most code we ever see.

                           Linus
