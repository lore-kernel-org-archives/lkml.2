Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020Ab1EZPbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 11:31:11 -0400
Received: from mail.perches.com ([173.55.12.10]:2063 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757490Ab1EZPbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 11:31:08 -0400
Subject: Re: [patch] net/core/filter.c: Fix build error
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ben Greear <greearb@candelatech.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org
In-Reply-To: <20110526123153.GA16002@elte.hu>
References: <cover.1305999731.git.joe@perches.com>
	 <efa062542c692c3f7743bf2d97b5987ab989e27e.1305999731.git.joe@perches.com>
	 <20110526123153.GA16002@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 08:31:06 -0700
Message-ID: <1306423866.16087.10.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 14:31 +0200, Ingo Molnar wrote:
> * Joe Perches <joe@perches.com> wrote:
> > A mis-configured filter can spam the logs with lots of stack traces.
> > Rate-limit the warnings and add printout of the bogus filter information.
> > Original-patch-by: Ben Greear <greearb@candelatech.com>
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  net/core/filter.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 0eb8c44..0e3622f 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -350,7 +350,9 @@ load_b:
> >  			continue;
> >  		}
> >  		default:
> > -			WARN_ON(1);
> > +			WARN_RATELIMIT(1, "Unknown code:%u jt:%u tf:%u k:%u\n",
> > +				       fentry->code, fentry->jt,
> > +				       fentry->jf, fentry->k);
> >  			return 0;
> >  		}
> This change (now upstream) fails to build in about 20% of all 
> randconfigs. Fix is below.

We've had problems with ratelimit uses in the past
as well.

There's a logical separation issue with the #includes
of bug.h, printk.h, ratelimit.h kernel.h and the
spinlock includes.

My suggestion would be to see about again adding
#include <linux/ratelimit.h> somehow
back to kernel.h which commit 3fff4c42bd0a removed
in 2009 because of the spinlock issues.

Any suggestion on how best to fix it generically?


