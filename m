Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab2GCVXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 17:23:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab2GCVXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 17:23:49 -0400
Date: Tue, 3 Jul 2012 14:23:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chinmay V S <cvs268@gmail.com>
Cc: Vlad Zolotarov <vlad@scalemp.com>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shai@scalemp.com
Subject: Re: [PATCH RESEND] fs: Move bh_cachep to the __read_mostly section
Message-Id: <20120703142348.3c963378.akpm@linux-foundation.org>
In-Reply-To: <CAK-9PRBi3XOVtW3gs3doO=ecD0XWfNffVefdRCC1sGnLdT_9LA@mail.gmail.com>
References: <2325453.OX7ktP55U1@vlad>
	<6810708.ZQq4lbXqoi@vlad>
	<CAK-9PRCb1jJdejvim48LP7GN6jHKDdkKVx-UY1Gpsbx1ROyQvQ@mail.gmail.com>
	<2779342.rcjlfQh1rr@vlad>
	<CAK-9PRBi3XOVtW3gs3doO=ecD0XWfNffVefdRCC1sGnLdT_9LA@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2012 23:54:09 +0530
Chinmay V S <cvs268@gmail.com> wrote:

> Hi Vlad,
> 
> I suppose we both are looking at opposite sides of the same coin.
> While i am wary of the potential pitfalls,
> you have focused on the benefits of using __read_mostly.
> 
> At this point i would like to send out a shout to everyone concerned to please
> clarify the status of __read_mostly:
> 
> 1. Is it being actively pursued? (systems that *will* clearly benefit from it)
> 2. Any actual results on real world use-cases? (w/ & w/o __read_mostly)
> 3. Is __read_mostly being accepted in non-architecture specific kernel code?
> 4. Is anyone working on a potential replacement for it?

I don't recall ever having seen any serious work justifying or
condemning __read_mostly.  It's one of those things which seemed a good
idea at the time, got added and nobody did anything further with it, as
far as I know.  I've always been rather wobbly about it, for reasons
discussed up-thread.


As for this particular patch: I've not seen any reason to do anything
with it, because the changelog doesn't describe why the patch is
needed.  If some performance problem has been encountered then that
should have been fully described in the patch changelog.


If some problem has indeed been observed then an alternative to
__read_mostly is to pad bh_cachep to a cacheline boundary with
____cacheline_aligned_in_smp or similar.  Or, perhaps better, identify
the variable which bh_cachep is sharing with, and pad *that* variable
to a cacheline so it can't cause cache thrashing with something else in
the future.  And once this mystery variable is identified, we can
perhaps beneficially group it into the same cacheline with some other
variables which are related to it.

But I'm madly guessing and can't say aything dispositive or even
useful, because we haven't been told what the problem was.  Still.

