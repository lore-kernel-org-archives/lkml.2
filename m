Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab0EKSlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:41:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754459Ab0EKSlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:41:06 -0400
Date: Tue, 11 May 2010 11:38:36 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 2/2] x86 platform driver: intelligent power sharing
 driver
Message-Id: <20100511113836.3c6ade8e.akpm@linux-foundation.org>
In-Reply-To: <20100511111854.658a5520@virtuousgeek.org>
References: <20100510142521.5a705dea@virtuousgeek.org>
	<20100510142652.12ca0824@virtuousgeek.org>
	<20100510220046.3f7cd9bf.akpm@linux-foundation.org>
	<20100511075919.39b768fc@virtuousgeek.org>
	<20100511111854.658a5520@virtuousgeek.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010 11:18:54 -0700 Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> > > > +#define thm_writeb(off, val) writeb((val), ips->regmap + (off))
> > > > +#define thm_writew(off, val) writew((val), ips->regmap + (off))
> > > > +#define thm_writel(off, val) writel((val), ips->regmap + (off))
> > > 
> > > ick.
> > > 
> > > static inline unsigned short thm_readw(struct ips_driver *ips, unsigned offset)
> > > {
> > > 	readw(ips->regmap + offset);
> > > }
> > > 
> > > would be nicer.
> > 
> > Yes, it would.
> 
> No, I take that back, it just means more typing.  This idiom of
> expecting a given variable to be declared for the IO routines to work
> is pretty common in drivers,

yeah, but it sucks there, too.

> and saves a bunch of redundant "(ips," everywhere...

It's not redundant - it's C.

grr.
