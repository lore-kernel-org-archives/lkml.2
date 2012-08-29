Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab2H2Iv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 04:51:26 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42274 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab2H2IvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 04:51:25 -0400
Date: Wed, 29 Aug 2012 11:51:12 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: dedekind1@gmail.com
Cc: Huang Shijie <shijie8@gmail.com>, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mtd: cmdlinepart: fix the wrong partitions number
 when truncating occurs
Message-ID: <20120829115112.389fc40c@halley>
In-Reply-To: <1346228165.2848.432.camel@sauron.fi.intel.com>
References: <1345904767-23011-1-git-send-email-shijie8@gmail.com>
	<20120825120231.73577d6a@halley>
	<CAMiH66HyfNEzEHGyZUcLJ_01PNVHqA44fjAqXsyM2c-HHms8hQ@mail.gmail.com>
	<20120826090603.6b833e54@pixies.home.jungo.com>
	<1346228165.2848.432.camel@sauron.fi.intel.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Aug 2012 11:16:05 +0300 Artem Bityutskiy <dedekind1@gmail.com> wrote:
> On Sun, 2012-08-26 at 09:06 +0300, Shmulik Ladkani wrote:
> > root	100m@0
> > kernel	100m@100m
> > rootfs	800m@200m (truncated)
> > user	0@1g (truncated)
> > rest	0@1g
> 
> Who would benefit from having those 2 0-sized partitions and how? How
> many users/scripts would be confused by this (these 2 ghost partitions
> would be visible in /proc/mtd and sysfs)? How much RAM would we spend
> for creating sysfs files and directories for these ghost partitions
> (note, one sysfs file costs a couple KiB I thing, because 'sizeof
> (struct inode)').
> 
> While you suggestion is clever, do we really benefit from this?

Artem, please note this is just a side effect of what I've suggested
(that its, continue parsing after first truncated partition), not a real
use case I'd expect and intentionally wish to support.

I am used to specify partitions explicitly using size@offset (specifying
offset for all parts, even if sometimes adjacent), and sometimes in an
unsorted fashion.
I never defined some partition that got truncated, so the whole
discussion is theoretical to _my_ usecase.

The only benefit of continuing to parse, is that if there _are_ later
partitions which are defined _explicitly_ with an offset, whose location
is _before_ the truncated partition, these would still be parsed and
registered.

Not so important, and would rarely happen, but simplistic and naive.

And reagrding 0 sized partitions, we can always skip these.

Regards,
Shmulik
