Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab1KNSUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 13:20:37 -0500
Received: from smtprelay.restena.lu ([158.64.1.62]:40159 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab1KNSUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 13:20:36 -0500
Date: Mon, 14 Nov 2011 19:20:26 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Joe Perches <joe@perches.com>, Huang Ying <ying.huang@intel.com>
Cc: William Douglas <william.r.douglas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Printk mulitple line message support
Message-ID: <20111114192026.73afb5b8@neptune.home>
In-Reply-To: <1321281640.2004.6.camel@Joe-Laptop>
References: <1321253936.13860.35.camel@yhuang-dev>
	<1321281640.2004.6.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 November 2011 Joe Perches <joe@perches.com> wrote:

> On Mon, 2011-11-14 at 14:58 +0800, Huang Ying wrote:
> > Hi,
> > 
> > In most cases, printk only guarantees messages from different printk
> > calling will not be interleaved between each other.  But many printk
> > users uses multiple line to form a complete message and call printk
> > for each line.  So the following situation is possible for two printk
> > users running on two CPUs.
> > 
> > line 1 of message from printk user1
> > line 1 of message from printk user2
> > line 2 of message from printk user1
> > line 2 of message from printk user2
> > 
> > This makes kernel log hard to read.  One possible solution to this
> > issue is to give a sequence number (or ID) to each complete message.
> > So the above lines will be:
> > 
> > {1}line 1 of message from printk user1
> > {2}line 1 of message from printk user2
> > {1}line 2 of message from printk user1
> > {2}line 2 of message from printk user2
> > 
> > Then some simple script can be used to group lines together according
> > to sequence number in lines.
> > 
> > What do you think about that?
> 
> This makes the typical multi-part but non-interleaved
> output difficult to read.
> 
> How about determining if there is interleaving and
> emitting sequence # only in those cases?
> 
> Perhaps test the atomic for the last sequence #.

Wouldn't another option be to let printk() handle '\n' in messages
so the multi-line messages could be done with a single call to printk.

Those messages could contain optional severity information after the
linefeed (if none given, the one of previous line would be repeated
internally by printk).

This way consumers of printk (and all variations of it like dev_err)
would all benefit without need to redefine them for multi-line use.

Bruno
