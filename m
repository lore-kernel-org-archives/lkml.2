Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab1BXGCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 01:02:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752106Ab1BXGCj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 01:02:39 -0500
MIME-Version: 1.0
In-Reply-To: <20110224165328.46c1169b@notabene.brown>
References: <20110224165328.46c1169b@notabene.brown>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 Feb 2011 22:01:49 -0800
Message-ID: <AANLkTinm95OYw2Sj0DuABTiG6eWzePcfAZyxOE0c4GsT@mail.gmail.com>
Subject: Re: [PULL REQUEST] md and related patches for 2.6.38
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Patterson <andrew.patterson@hp.com>,
        Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 9:53 PM, NeilBrown <neilb@suse.de> wrote:
>
>  The most noteworthy is :
>       Fix over-zealous flush_disk when changing device size.
>
>  which I include below in full.

Gah.

Why did you do that butt-ugly "__invalidate_device2()"?

There are something like three users of that existing
__invalidate_device() function, it would have made for a smaller and
cleaner patch to just fix them all, rather than change the calling
convention, create that ugly "2" function, and add the wrapper
function.

It's _doubly_ crazy, because that's exactly what you did to
"invalidate_inodes()", so it has this crazy mix of "change one
function" and "try to maintain another function unchanged".

Why?

                 Linus
