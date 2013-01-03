Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab3ACJOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 04:14:21 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:11643
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751670Ab3ACJOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 04:14:19 -0500
X-IronPort-AV: E=Sophos;i="4.84,402,1355094000"; 
   d="scan'208";a="167325376"
Date: Thu, 3 Jan 2013 10:14:13 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Tony Prisk <linux@prisktech.co.nz>, Dan Carpenter <error27@gmail.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        kernel-janitors@vger.kernel.org,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH RESEND 6/6] clk: s5p-g2d: Fix incorrect usage of
 IS_ERR_OR_NULL
In-Reply-To: <20130103090520.GC7247@mwanda>
Message-ID: <alpine.DEB.2.02.1301031010400.1989@hadrien>
References: <1355852048-23188-1-git-send-email-linux@prisktech.co.nz> <1355852048-23188-7-git-send-email-linux@prisktech.co.nz> <50D62BC9.9010706@mvista.com> <50E32C06.5020104@gmail.com> <CA+_b7DK2zbBzbCh15ikEAeGP5h-V9gQ_YcX15O-RNvWxCk8Zfg@mail.gmail.com>
 <1357104713.30504.8.camel@gitbox> <20130103090520.GC7247@mwanda>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jan 2013, Dan Carpenter wrote:

> On Wed, Jan 02, 2013 at 06:31:53PM +1300, Tony Prisk wrote:
> > On Wed, 2013-01-02 at 08:10 +0300, Dan Carpenter wrote:
> > > clk_get() returns NULL if CONFIG_HAVE_CLK is disabled.
> > >
> > > I told Tony about this but everyone has been gone with end of year
> > > holidays so it hasn't been addressed.
> > >
> > > Tony, please fix it so people don't apply these patches until
> > > clk_get() is updated to not return NULL.  It sucks to have to revert
> > > patches.
> > >
> > > regards,
> > > dan carpenter
> >
> > I posted the query to Mike Turquette, linux-kernel and linux-arm-kernel
> > mailing lists, regarding the return of NULL when HAVE_CLK is undefined.
> >
> > Short Answer: A return value of NULL is valid and not an error therefore
> > we should be using IS_ERR, not IS_ERR_OR_NULL on clk_get results.
> >
> > I see the obvious problem this creates, and asked this question:
> >
> > If the driver can't operate with a NULL clk, it should use a
> > IS_ERR_OR_NULL test to test for failure, rather than IS_ERR.
> >
> >
> > And Russell's answer:
> >
> > Why should a _consumer_ of a clock care?  It is _very_ important that
> > people get this idea - to a consumer, the struct clk is just an opaque
> > cookie.  The fact that it appears to be a pointer does _not_ mean that
> > the driver can do any kind of dereferencing on that pointer - it should
> > never do so.
> >
> > Thread can be viewed here:
> > https://lkml.org/lkml/2012/12/20/105
> >
>
> Ah.  Grand.  Thanks...
>
> Btw. The documentation for clk_get() really should include some of
> this information.  I know Russell thinks that the driver authors are
> stupid and lazy, and it's probably true.  But if everyone makes the
> same mistake over and over, then it probably means we could put a
> special note:
>
> "Do not check this with IS_ERR_OR_NULL().  Null values are not an
> error.  Drivers should treat the return value as an opaque cookie
> and they should not dereference it."
>
> This is probably there in the file somewhere else, but I searched
> for "opaque", "cookie", and "dereference" and I didn't find
> anything.  I'm not saying the documentation isn't perfect, just that
> driver authors are lazy and stupid but we can't kill them so we have
> to live with them.

I still think it would also be helpful for the definition that returns
NULL to have some documentation associated with it.  Having a feature
disabled and then trying to use the feature could reasonably considered to
lead to a failure, so it is not obvious what the NULL represents.

julia
