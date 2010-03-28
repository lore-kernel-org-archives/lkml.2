Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab0C1OGJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 10:06:09 -0400
Received: from mail-qy0-f188.google.com ([209.85.221.188]:50139 "EHLO
	mail-qy0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab0C1OGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 10:06:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:subject:to:cc:in-reply-to:references;
        b=A3mOucYmMsvv2SwsJB2jmIGRvLCqN4Wf+GIOOvnygw7Kdfq0kG61vUsYEAhI5pZQH0
         VqfGqKfzgmlySP1114nB/W9M9W+gOiYxEmsCk+FMfm9sb3Ng5Wrmx0ZFgk+7fFEBIE7y
         WohmP20DWhARfxskfzHlKN6o6ELzcKVN9QFFM=
Message-ID: <4baf624c.48c3f10a.16d0.ffffccb8@mx.google.com>
Date: Sun, 28 Mar 2010 07:06:04 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, tytso@mit.edu, npiggin@suse.de,
       mingo@elte.hu, Ruald Andreae <ruald.a@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, Olly Betts <olly@survex.com>,
       martin f krafft <madduck@madduck.net>
In-Reply-To: <20100327204233.0d84542a@infradead.org>
References: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com>
	<4baeaee5.c5c2f10a.7187.2688@mx.google.com>
	<20100327204233.0d84542a@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Mar 2010 20:42:33 -0700, Arjan van de Ven <arjan@infradead.org> wrote:
> On Sat, 27 Mar 2010 18:20:37 -0700 (PDT)
> Ben Gamari <bgamari.foss@gmail.com> wrote:
> 
> > Hey all,
> > 
> > I have posted another profile[1] from an incident yesterday. As you
> > can see, both swapper and init (strange?) show up prominently in the
> > profile. Moreover, most processes seem to be in blk_peek_request a
> > disturbingly large percentage of the time. 
> > 
I suppose this statement was a tad misleading. The provided profiles were taken
with,

perf record -f -g -a -e block:block_rq_issue -c 1

Which I believe measures block requests issued, not CPU usage (correct me if
I'm wrong).

> profiles tend to be about cpu usage... and are rather poor to deal with
> anything IO related.
> 
See above.

> latencytop might get closer in giving useful information....
> 
Latencytop generally shows a large amount of time handling page faults.

> (btw some general suggestion.. make sure you're using noatime or
> relatime as mount option) 

Thanks for the suggestion. I had actually forgotten relatime in my fstab, so
we'll see if there's any improvement now. That being said, I/O loads over small
numbers of files (e.g. xapian) are just as bad as loads over large numbers of
files. To me that weakly suggests perhaps atime updates aren't the issue (I
could be horribly wrong though).

- Ben

