Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab1JYA5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 20:57:07 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52947 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137Ab1JYA5E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 20:57:04 -0400
MIME-Version: 1.0
In-Reply-To: <1317162613-11060-3-git-send-email-dledford@redhat.com>
References: <1317162613-11060-1-git-send-email-dledford@redhat.com> <1317162613-11060-3-git-send-email-dledford@redhat.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Mon, 24 Oct 2011 20:56:44 -0400
Message-ID: <CAHGf_=obvkUN-JYVfbLueTV3hmobnV3jY86ukHo1E6d-3NDZxg@mail.gmail.com>
Subject: Re: [PATCH 2/4] ipc/mqueue: switch back to using non-max values on create
To: Doug Ledford <dledford@redhat.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, joe.korty@ccur.com, amwang@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Commit b231cca4381ee15ec99afbfb244fbc0324869927 changed
> how we create a queue that does not include an attr
> struct passed to open so that it creates the queue
> with whatever the maximum values are.  However, if the
> admin has set the maximums to allow flexibility in
> creating a queue (aka, both a large size and large queue
> are allowed, but combined they create a queue too large
> for the RLIMIT_MSGQUEUE of the user), then attempts to
> create a queue without an attr struct will fail.  Switch
> back to using acceptable defaults regardless of what
> the maximums are.
>
> Signed-off-by: Doug Ledford <dledford@redhat.com>

NAK.

Commit b231cca is 3 years old commit. It's too late to revert.
Moreover Commit b231cca changed hardcoded limit to kernel knob,
and this patch do reverse. Of course, latter direction changes almost
always bring us compatibility issue.

   commit b231cca4381ee15ec99afbfb244fbc0324869927
   Author: Joe Korty <joe.korty@ccur.com>
   Date:   Sat Oct 18 20:28:32 2008 -0700

       message queues: increase range limits

The right way is to create new knob likes mqueue/msgsize_default
and to separate default and maximum value.
