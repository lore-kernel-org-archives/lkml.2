Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab3AGWM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 17:12:26 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:57110 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab3AGWMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 17:12:23 -0500
Date: Mon, 7 Jan 2013 14:12:19 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, Zach Brown <zab@redhat.com>,
        bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, tytso@mit.edu
Subject: Re: [PATCH 04/32] aio: remove retry-based AIO
Message-ID: <20130107221219.GC26407@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
 <1356573611-18590-5-git-send-email-koverstreet@google.com>
 <CAJd=RBD7RqscJpw+3Gq9a8P9=mES1SqLFCx1f0p5AM8VufOGCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBD7RqscJpw+3Gq9a8P9=mES1SqLFCx1f0p5AM8VufOGCg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2012 at 03:36:38PM +0800, Hillf Danton wrote:
> On Thu, Dec 27, 2012 at 9:59 AM, Kent Overstreet <koverstreet@google.com> wrote:
> > -       /*
> > -        * This is so that aio_complete knows it doesn't need to
> > -        * pull the iocb off the run list (We can't just call
> > -        * INIT_LIST_HEAD because we don't want a kick_iocb to
> > -        * queue this on the run list yet)
> > -        */
> > -       iocb->ki_run_list.next = iocb->ki_run_list.prev = NULL;
> 
> The tricky, list.next = NULL, is erased here, but it is reused in one of
> the subsequent patches, why?

I think you're confusing the two different linked lists - there's
ki_run_list, which isn't used anymore after this patch (and deleted
here), and ki_list, which is used for cancellation.

Yeah, it's tricky and ugly.
