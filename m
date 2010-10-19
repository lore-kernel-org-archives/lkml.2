Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab0JSWu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 18:50:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755945Ab0JSWu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:50:27 -0400
Subject: Re: [PATCH 1/3] IMA: move read/write counters into struct inode
From: Eric Paris <eparis@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org, mingo@elte.hu
In-Reply-To: <AANLkTimL=eChoCQHGoiouE5s6dGG=n9ZAQGhW-RW+gDj@mail.gmail.com>
References: <20101019011650.25346.99614.stgit@paris.rdu.redhat.com>
	 <AANLkTimGdjPyLXuknDNa7WNthDT9+2FdOuPdxwjRiMHD@mail.gmail.com>
	 <1287506215.2530.187.camel@localhost.localdomain>
	 <20101019165530.GT19804@ZenIV.linux.org.uk>
	 <AANLkTimL=eChoCQHGoiouE5s6dGG=n9ZAQGhW-RW+gDj@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Oct 2010 18:49:06 -0400
Message-ID: <1287528546.2530.277.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Executive summary of the day's work:
Yesterday morning: 944 bytes per inode in core
Yesterday night: 24 bytes per inode in core
Tonight: 4 bytes per inode in core.

That's a x236 time reduction in memory usage.  No I didn't even start
looking at a freezer.  Which could bring that 4 down to 0, but would add
a scalability penalty on all inodes when IMA was enabled.

The memory associated with inodes that IMA actually cares about has gone
from 312 to 320 bytes.  

I'm going to follow up with my patch series again but they aren't really
ready to be applied.  The IBM people who wrote IMA are reviewing them.
I have some questions if my RCU+RBTREE usage is valid/correct.  I'd
really like Al to take a close look at the last patch in the series to
make sure my use of i_writecount actually does what I want it to do...

-Eric

