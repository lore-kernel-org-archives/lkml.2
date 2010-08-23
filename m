Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab0HWOq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 10:46:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55113 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab0HWOq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 10:46:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] posix clocks: introduce syscall for clock tuning.
Date: Mon, 23 Aug 2010 16:46:00 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Richard Cochran <richardcochran@gmail.com>,
        john stultz <johnstul@us.ibm.com>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1282550649.git.richard.cochran@omicron.at> <201008231457.26690.arnd@arndb.de> <20100823134330.GM12892@parisc-linux.org>
In-Reply-To: <20100823134330.GM12892@parisc-linux.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008231646.00357.arnd@arndb.de>
X-Provags-ID: V02:K0:GTVNLpxdWjxkIdh+IE/x7xqu9wg9248ytzc3EjtXzrH
 KqT00YBYGpo0itqDHIa3LtUwMkv8+CnSf7C6GBlQdHiO3o07mT
 dW54cq6EYGYuMemuULyngPErClH0B6XIQ1UW8D/oMHlohgDg2h
 AJEfSiYaooVvj8entOAhEmJqNGrzD8Ai/4jveKSHjWuzfP8SPw
 R1P/Eo6KCtrBT5mdPJ9Zg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 August 2010, Matthew Wilcox wrote:
> On Mon, Aug 23, 2010 at 02:57:26PM +0200, Arnd Bergmann wrote:
> > > +static inline int common_clock_adj(const clockid_t which_clock, int ppb,
> > > +                              struct timespec *tp)
> > > +{
> > > +   return -EOPNOTSUPP;
> > > +}
> > > +
> > >  static int no_timer_create(struct k_itimer *new_timer)
> > >  {
> > >     return -EOPNOTSUPP;
> > 
> > So we already return -EOPNOTSUPP in some cases? The man page does not document this.
> > I wonder if we should change that to -EINVAL as well.
> 
> ENOTTY is the usual errno for "inappropriate ioctl for device".  Due to
> the way this patch has been chopped up, I can't tell if that's what is
> intended here.

It's for the CLOCK_* syscall family, which I think is different enough from
an ioctl that ENOTTY makes no sense.

The documented return values of timer_create() are EAGAIN, EINVAL and
ENOMEM.

	Arnd
