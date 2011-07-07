Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab1GGSgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:36:46 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64692 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab1GGSgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:36:44 -0400
MIME-Version: 1.0
In-Reply-To: <4E1477B9.1050701@kernel.dk>
References: <CAG4TOxP1eTY_R_t57U1Ux=RTFa=3BWWL9yzL-p9sC+YWrpZmYQ@mail.gmail.com>
 <4E1477B9.1050701@kernel.dk>
From: Roland Dreier <roland@kernel.org>
Date: Thu, 7 Jul 2011 11:36:24 -0700
X-Google-Sender-Auth: IkQArzPWvrevCfDGofPDFVSnX0s
Message-ID: <CAG4TOxN7Dqk0=WcbWV33ZsTdqFtQRwoOM87Q2v8=LT5fviVZhg@mail.gmail.com>
Subject: Re: warning because of race between userspace and add_disk()?
To: Jens Axboe <axboe@kernel.dk>
Cc: open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It certainly looks like it, we need to order disk_add_events() before
> register_disk() or handle this more gracefully. I'll cook up a patch.

Cool.  By the way, have you seen the threads about use-after-free
problems with q->elevator?  The issue seems to be that when devices
disappear, we do blk_cleanup_queue() (which frees q->elevator) but if
someone has the device still open, we still have references to the
queue and requests can still come in (and blow up when they try to use
the elevator).

By the way, are you planning on going to that Intel Tech Days thing
in a couple of weeks?  (I should be there)

 - R.
