Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab2L2Hgl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 02:36:41 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:63733 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab2L2Hgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 02:36:39 -0500
MIME-Version: 1.0
In-Reply-To: <1356573611-18590-5-git-send-email-koverstreet@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
	<1356573611-18590-5-git-send-email-koverstreet@google.com>
Date: Sat, 29 Dec 2012 15:36:38 +0800
Message-ID: <CAJd=RBD7RqscJpw+3Gq9a8P9=mES1SqLFCx1f0p5AM8VufOGCg@mail.gmail.com>
Subject: Re: [PATCH 04/32] aio: remove retry-based AIO
From: Hillf Danton <dhillf@gmail.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, Zach Brown <zab@redhat.com>,
        bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, tytso@mit.edu
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2012 at 9:59 AM, Kent Overstreet <koverstreet@google.com> wrote:
> -       /*
> -        * This is so that aio_complete knows it doesn't need to
> -        * pull the iocb off the run list (We can't just call
> -        * INIT_LIST_HEAD because we don't want a kick_iocb to
> -        * queue this on the run list yet)
> -        */
> -       iocb->ki_run_list.next = iocb->ki_run_list.prev = NULL;

The tricky, list.next = NULL, is erased here, but it is reused in one of
the subsequent patches, why?

Hillf
