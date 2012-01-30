Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab2A3Udb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 15:33:31 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:58687 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab2A3Ud3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 15:33:29 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap0EAKb9Jk9bdWOb/2dsb2JhbABDr1uBcgEBBAEyASMjEAsYHBIUJQMhiA8DuFGIPQEDBBANBAMENhSCdwIBAwcCHWo0glRjBJUZhVeDVokm
X-IronPort-AV: E=Sophos;i="4.71,592,1320620400"; 
   d="scan'208";a="862426423"
Date: Mon, 30 Jan 2012 21:33:12 +0100
From: =?iso-8859-1?Q?V=EDctor_M=2E_J=E1quez_L=2E?= <vjaquez@igalia.com>
To: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "Ramirez Luna, Omar" <omar.ramirez@ti.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Ivan Gomez Castellanos <ivan.gomez@ti.com>,
        Armando Uribe <x0095078@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 3/5] staging: tidspbridge: Lindent to drv_interface.c
Message-ID: <20120130203312.GA3296@lit.local.igalia.com>
References: <cover.1327348286.git.vjaquez@igalia.com>
 <7103a353d393f9b8366b141a608a4370e4392c7b.1327348286.git.vjaquez@igalia.com>
 <CAB-zwWjKfakESHw4Cw8JvJ6WpELz51E_9zVtjR0bF84yhMRfMQ@mail.gmail.com>
 <20120130192907.GX3294@mwanda>
 <1327953180.25132.39.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1327953180.25132.39.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 11:53:00AM -0800, Joe Perches wrote:
> On Mon, 2012-01-30 at 22:29 +0300, Dan Carpenter wrote:
> > On Mon, Jan 30, 2012 at 11:25:34AM -0600, Ramirez Luna, Omar wrote:
> > > > +                       pr_info("%s:%d handle(s) still opened\n", __func__,
> > > > +                               atomic_read(&bridge_cref));
> > > I remember the rule was to break lines as far to the right as
> > > possible, no? Chapter 2 CodingStyle, same for the other similar
> > > changes.
> > It doesn't mean you have to right justify things, it just means
> > indented.  The original code is fine here and the new code is fine
> > here.  It's up to whoever writes the code to decide.
> 
> I concur.
> 
> My personal preference is to use a new line after the format
> string if necessary.
> 
> ie:
> 	pr_<level>("fmt\n"[, args to 80 columns if all fit])
> or
> 	pr_<level>("fmt\n",
> 		   args when single line exceeds 80 columns);
> 
> So for this case:
> 			pr_info("%s:%d handle(s) still opened\n",
> 				__func__, atomic_read(&bridge_cref));
> 
> I've done a patch here to tidspbridge that standardizes
> printk output.
> 
> Basically, the patch adds
> #define pr_fmt(fmt) KBUILD_MODNAME "%s: ", __func__
> to prefix "tidspbridge:%s:", removes the leading
> "%s:...",  __func__ from the uses, coalesces
> formats and does argument alignment.
> 
> It cleans up the DBC_ASSERT, DBC_REQUIRE and DBC_ENSURE
> macros too.

hehehe... I also have one for this... But I prefer yours: I'm a newbie :)

vmjl

> 
> I'm waiting for the Makefile change and whatever
> patches Víctor produces to be applied.  I'll then
> redo my patch and submit it.
> 
> 
> 
