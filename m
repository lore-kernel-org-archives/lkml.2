Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab1BMRkG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 12:40:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751155Ab1BMRkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 12:40:02 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTikj-ZTS58uAqUmKQEWzdD3f5DJeox=gOJ9z8rSb@mail.gmail.com>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
 <m1hbce46fw.fsf@fess.ebiederm.org> <AANLkTikJL_4-7F_2oSuefSpL7ak3+OWLk7F+bDqWT8XJ@mail.gmail.com>
 <m1bp2ly41q.fsf@fess.ebiederm.org> <AANLkTimGH5mU+OLRKb=H3WgLXPZaSc5heR+4w5gj2aD4@mail.gmail.com>
 <AANLkTikj-ZTS58uAqUmKQEWzdD3f5DJeox=gOJ9z8rSb@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 13 Feb 2011 09:39:39 -0800
Message-ID: <AANLkTinjsimbe6-YgcSK0-zqDuoZ=8xCReHnKZoG4GU9@mail.gmail.com>
Subject: Re: Heads up Linux 2.6.38-rc4 compile problems.
To: Alex Riesen <raa.lkml@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 9, 2011 at 8:02 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Well, the thing is, Eric said he was using ext4.
>
> And there are absolutely no changes I can see after -rc3 that would
> affect anything like this.

Hmm. Eric - mind testing current -git?

J. R. Okajima found a possible problem with the new RCU filename
lookup, which could corrupt the filp_cache. I'd expect the normal
result to be an oops, but maybe there could be memory corruption. And
the easiest way to trigger it would probably be to have lots of
concurrent fs activity with renames.

Now, it's not new to -rc4: the whole rcu lookup thing was merged into
-rc1. But since I still don't see anything that looks likely to be
introduced after -rc3, it might not hurt to think that maybe it's just
rare enough that you just thought -rc3 was ok, and then you were
unlucky with -rc4.

                                Linus
