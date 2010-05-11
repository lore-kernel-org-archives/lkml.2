Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab0EKTAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 15:00:31 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:42657 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757417Ab0EKTA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 15:00:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=cl6ty8boY9UMmbRGEgzgttGpWsz9SnGhW9yLWmGJa7BCqzTI0ebIOVTD6YwvGeCB968y7lIq42fj304DnY/6oHAfXhKS1zBcxDZZLQy6FafrlEQl/kleVGaClaLDX7yo;
Date: Tue, 11 May 2010 11:59:39 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 2/2] x86 platform driver: intelligent power sharing
 driver
Message-ID: <20100511115939.6d68c5dd@virtuousgeek.org>
In-Reply-To: <20100511113836.3c6ade8e.akpm@linux-foundation.org>
References: <20100510142521.5a705dea@virtuousgeek.org>
	<20100510142652.12ca0824@virtuousgeek.org>
	<20100510220046.3f7cd9bf.akpm@linux-foundation.org>
	<20100511075919.39b768fc@virtuousgeek.org>
	<20100511111854.658a5520@virtuousgeek.org>
	<20100511113836.3c6ade8e.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010 11:38:36 -0400
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 11 May 2010 11:18:54 -0700 Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
> > > > > +#define thm_writeb(off, val) writeb((val), ips->regmap + (off))
> > > > > +#define thm_writew(off, val) writew((val), ips->regmap + (off))
> > > > > +#define thm_writel(off, val) writel((val), ips->regmap + (off))
> > > > 
> > > > ick.
> > > > 
> > > > static inline unsigned short thm_readw(struct ips_driver *ips, unsigned offset)
> > > > {
> > > > 	readw(ips->regmap + offset);
> > > > }
> > > > 
> > > > would be nicer.
> > > 
> > > Yes, it would.
> > 
> > No, I take that back, it just means more typing.  This idiom of
> > expecting a given variable to be declared for the IO routines to work
> > is pretty common in drivers,
> 
> yeah, but it sucks there, too.
> 
> > and saves a bunch of redundant "(ips," everywhere...
> 
> It's not redundant - it's C.
> 
> grr.

No, it's CPP; this is exactly what preprocessor abuse was intended
for. :)

But it's a mechanical search & replace if someone feels strongly about
it.  I'd like to avoid the typing though.

-- 
Jesse Barnes, Intel Open Source Technology Center
