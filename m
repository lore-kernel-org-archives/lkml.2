Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab1KYX4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 18:56:20 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45200 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab1KYX4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 18:56:19 -0500
Date: Sat, 26 Nov 2011 03:56:13 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Paul Parsons <lost.distance@yahoo.com>
Cc: Philipp Zabel <philipp.zabel@gmail.com>, linux-kernel@vger.kernel.org,
        mad_soft@inbox.ru, koen@dominion.thruhere.net
Subject: Re: [PATCH] power/ds2760_battery: Add rated capacity of the hx4700
 3600mAh battery
Message-ID: <20111125235613.GA21434@oksana.dev.rtsoft.ru>
References: <CA+gwMcf9xvcFNJoxmDO0z-FMhKrd=9eptSDrpsBB3a20pzMfKw@mail.gmail.com>
 <1322178776.45812.YahooMailClassic@web29011.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1322178776.45812.YahooMailClassic@web29011.mail.ird.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 11:52:56PM +0000, Paul Parsons wrote:
> --- On Thu, 24/11/11, Philipp Zabel <philipp.zabel@gmail.com> wrote:
> > > +#ifdef CONFIG_MACH_H4700
> > > +       0,
> > > +       3600,   /* HP iPAQ hx4700 3.7V 3600mAh
> > (359114-001) */
> > > +#endif
> > 
> > Is that #ifdef needed? I know there's another one a few
> > lines up, but
> > I think that one is already unfortunate and there is no
> > conflict here.
> 
> Yes it is needed, because the rated_capacities[] table must
> contain different values for different platforms. The #ifdefs
> preserve the original table for other platforms.
> 
> Agreed it's untidy. Ideally the table would be replaced by
> platform specific data. However it's not obvious which other
> platforms use the table, nor whether the original table is
> correct for those other platforms. I presume that the table
> was originally believed to be common for all ds2760 based
> platforms, but the hx4700 demonstrates this is not the case.

Well, the really bad thing is that ds2760 is on the hot-pluggable
bus, so basically there is no such thing as 'platform_data'. You
can basically attach any battery, with any value in the
rated_capacity 'register'. :-(

The only thing we can do is some machine-specific fixup. The
universal way is ds2760_battery.rate_capacity module (and kernel
command line) parameter that you can use to fixup the value.

But, having the MACH_HX4700 fixup is just a heuristic that
helps the driver to work on the particular machine 'out of
the box'.

The really bad thing about that patch is that it uses build-time
way for the heuristic. We should really call something like
machine_is(). But that would be architecture-specific today
(i.e. will only work on ARM). Heh.

So... I'm applying the patch as it is not a big deal, and we
have a similar machine fixup already.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
