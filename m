Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab2A3TxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 14:53:20 -0500
Received: from [206.117.179.246] ([206.117.179.246]:56553 "EHLO labridge.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752433Ab2A3TxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 14:53:19 -0500
Message-ID: <1327953180.25132.39.camel@joe2Laptop>
Subject: Re: [PATCH 3/5] staging: tidspbridge: Lindent to drv_interface.c
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Ramirez Luna, Omar" <omar.ramirez@ti.com>,
        =?ISO-8859-1?Q?V=EDctor?= Manuel =?ISO-8859-1?Q?J=E1quez?=
	 Leal <vjaquez@igalia.com>,
        devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Ivan Gomez Castellanos <ivan.gomez@ti.com>,
        Armando Uribe <x0095078@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Date: Mon, 30 Jan 2012 11:53:00 -0800
In-Reply-To: <20120130192907.GX3294@mwanda>
References: <cover.1327348286.git.vjaquez@igalia.com>
	 <7103a353d393f9b8366b141a608a4370e4392c7b.1327348286.git.vjaquez@igalia.com>
	 <CAB-zwWjKfakESHw4Cw8JvJ6WpELz51E_9zVtjR0bF84yhMRfMQ@mail.gmail.com>
	 <20120130192907.GX3294@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-30 at 22:29 +0300, Dan Carpenter wrote:
> On Mon, Jan 30, 2012 at 11:25:34AM -0600, Ramirez Luna, Omar wrote:
> > > +                       pr_info("%s:%d handle(s) still opened\n", __func__,
> > > +                               atomic_read(&bridge_cref));
> > I remember the rule was to break lines as far to the right as
> > possible, no? Chapter 2 CodingStyle, same for the other similar
> > changes.
> It doesn't mean you have to right justify things, it just means
> indented.  The original code is fine here and the new code is fine
> here.  It's up to whoever writes the code to decide.

I concur.

My personal preference is to use a new line after the format
string if necessary.

ie:
	pr_<level>("fmt\n"[, args to 80 columns if all fit])
or
	pr_<level>("fmt\n",
		   args when single line exceeds 80 columns);

So for this case:
			pr_info("%s:%d handle(s) still opened\n",
				__func__, atomic_read(&bridge_cref));

I've done a patch here to tidspbridge that standardizes
printk output.

Basically, the patch adds
#define pr_fmt(fmt) KBUILD_MODNAME "%s: ", __func__
to prefix "tidspbridge:%s:", removes the leading
"%s:...",  __func__ from the uses, coalesces
formats and does argument alignment.

It cleans up the DBC_ASSERT, DBC_REQUIRE and DBC_ENSURE
macros too.

I'm waiting for the Makefile change and whatever
patches Víctor produces to be applied.  I'll then
redo my patch and submit it.


