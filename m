Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab0EKSTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:19:38 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:58140 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932354Ab0EKSTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:19:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=q5y/VHtP+XQIBJbjd0QE5cInoxANAFEtiPx0kNPJm9WVHkoIdU4XPt5mG8Vp4Z9Rg8aYa/xKrRPtDusSkbObeTT5qPE8hUVALq8Skg+nJxNT4JUqWtvImZlI2SuF7WNW;
Date: Tue, 11 May 2010 11:18:54 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       intel-gfx@lists.freedesktop.org, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 2/2] x86 platform driver: intelligent power sharing
 driver
Message-ID: <20100511111854.658a5520@virtuousgeek.org>
In-Reply-To: <20100511075919.39b768fc@virtuousgeek.org>
References: <20100510142521.5a705dea@virtuousgeek.org>
	<20100510142652.12ca0824@virtuousgeek.org>
	<20100510220046.3f7cd9bf.akpm@linux-foundation.org>
	<20100511075919.39b768fc@virtuousgeek.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010 07:59:19 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Mon, 10 May 2010 22:00:46 -0400
> Andrew Morton <akpm@linux-foundation.org> wrote:
> > > +#define thm_readb(off) readb(ips->regmap + (off))
> > > +#define thm_readw(off) readw(ips->regmap + (off))
> > > +#define thm_readl(off) readl(ips->regmap + (off))
> > > +#define thm_readq(off) readq(ips->regmap + (off))
> > > +
> > > +#define thm_writeb(off, val) writeb((val), ips->regmap + (off))
> > > +#define thm_writew(off, val) writew((val), ips->regmap + (off))
> > > +#define thm_writel(off, val) writel((val), ips->regmap + (off))
> > 
> > ick.
> > 
> > static inline unsigned short thm_readw(struct ips_driver *ips, unsigned offset)
> > {
> > 	readw(ips->regmap + offset);
> > }
> > 
> > would be nicer.
> 
> Yes, it would.

No, I take that back, it just means more typing.  This idiom of
expecting a given variable to be declared for the IO routines to work
is pretty common in drivers, and saves a bunch of redundant "(ips,"
everywhere...

> > afacit these messages might come out at one-per-five-seconds max?
> > 
> > I bet the driver blows up and someone's logs get spammed ;)
> 
> Possibly. :)  I added these at the request of Pavel; I could make them
> just print one time though...

These should be dev_warn instead anyway.

Updated patch on its way.

-- 
Jesse Barnes, Intel Open Source Technology Center
