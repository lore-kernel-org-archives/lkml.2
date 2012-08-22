Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203Ab2HVEA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 00:00:58 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:60408 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab2HVEAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 00:00:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120821101505.61c0221a@pyramind.ukuu.org.uk>
References: <1345531207-24926-1-git-send-email-airlied@redhat.com>
	<20120821101505.61c0221a@pyramind.ukuu.org.uk>
Date: Wed, 22 Aug 2012 14:00:05 +1000
Message-ID: <CAPM=9tzv=YKEfvmN+18huXGd7ZO-AGvcAsrD8m7NQh5twEfbhw@mail.gmail.com>
Subject: Re: [PATCH] fbcon: fix race condition between console lock and cursor timer
From: Dave Airlie <airlied@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dave Airlie <airlied@redhat.com>, linux-fbdev@vger.kernel.org,
        dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Josh Boyer <jwboyer@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 7:15 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> So after much tracing with direct netconsole writes (printks
>> under console_lock not so useful), I think I found the race.
>
> Direct netconsole write would be a useful patch to have mainline I think
> 8)

Well I used a one line wrapper around the netconsole write_msg, which
just passed
NULL as the first arg, then sprinkled netconsole_write_msg around the
place, not having
printf stuff could be an annoyance for some people, for this it didn't matter.

Peter I wish I had a serial port to work with :-)

>
> Not really the proper fix but its clear and is probably the best thing to
> go in initially with a cc: stable. Can you at least stick a large
>
> + /* FIXME: we should sort out the unbind locking instead */

Done, and cc stable, I'll send this to Linus via my tree as its fairly
urgent from my pov.

Dave.
