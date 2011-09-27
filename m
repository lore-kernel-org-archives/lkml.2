Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab1I0XxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 19:53:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38134 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab1I0XxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 19:53:09 -0400
MIME-Version: 1.0
In-Reply-To: <4E79D65A.6070406@kernel.dk>
References: <4E79D65A.6070406@kernel.dk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 27 Sep 2011 16:52:48 -0700
X-Google-Sender-Auth: JfW4JtbDSU62fWqOcRCYH9AktiA
Message-ID: <CA+55aFxWHBEBaWfWcdOHucAiMHnTH+y1WRq6gik+=NGA1FNh=Q@mail.gmail.com>
Subject: Re: [GIT PULL] block fixes for 3.1-rc
To: Jens Axboe <axboe@kernel.dk>, James Bottomley <jbottomley@parallels.com>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 5:19 AM, Jens Axboe <axboe@kernel.dk> wrote:
>
> Final round of patches for 3.1.

Apparently better not.

The "block layer oopses on USB device removal" is still there, it seems.

I can even find a patch from it from Alan Stern:

   https://lkml.org/lkml/2011/9/18/63

and the reason I found that was that my wife's machine just saw what
looks very much like that bug in elv_put_request().

The call chain on that particular machine was:

 - __blk_put_request
  blk_put_request
  scsi_execute
  scsi_execute_req
  sd_check_events
  disk_events_workfn
  process_one_work

in one of the kthread helpers. It sounds like something either
generates disk events after the unplug event (despite a "safely
remove" thing), or doesn't properly wait for the disk events to have
flushed before the elevator is cleared.

The "things go oops at USB removal" reports have been with us for a
*loong* time now. Can we please get this fixed already, and have
somebody really look at it?

And if you can't figure out why it happens, at least apply Alan's
patch (or ack it).

                  Linus
