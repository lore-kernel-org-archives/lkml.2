Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab3AHQHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 11:07:00 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:53486 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803Ab3AHQG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 11:06:58 -0500
Date: Tue, 8 Jan 2013 08:06:54 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, zab@redhat.com,
        bcrl@kvack.org, viro@zeniv.linux.org.uk, tytso@mit.edu
Subject: Re: [PATCH 29/32] block, aio: Batch completion for bios/kiocbs
Message-ID: <20130108160654.GA25098@localhost>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
 <1356573611-18590-32-git-send-email-koverstreet@google.com>
 <50E69F5B.8060902@kernel.dk>
 <20130107233443.GG26407@google.com>
 <x49r4lvadvl.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49r4lvadvl.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 10:33:18AM -0500, Jeff Moyer wrote:
> Kent Overstreet <koverstreet@google.com> writes:
> 
> >> Is the rbtree really faster than a basic (l)list and a sort before
> >> completing them? Would be simpler.
> >
> > Well, depends. With one or two kioctxs? The list would definitely be
> > faster, but I'm loathe to use an O(n^2) algorithm anywhere where the
> > input size isn't strictly controlled, and I know of applications out
> > there that use tons of kioctxs.
> 
> Out of curiosity, what applications do you know of that use tons of
> kioctx's?

"tons" is relative I suppose, but before this patch series sharing a
kioctx between threads was really bad for performance and... you know
how people can be with threads.
