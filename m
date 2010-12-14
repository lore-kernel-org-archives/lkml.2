Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202Ab0LNVYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 16:24:16 -0500
Received: from smtp.falooley.org ([66.180.170.91]:42074 "EHLO
	smtp.falooley.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760113Ab0LNVYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 16:24:15 -0500
Date: Tue, 14 Dec 2010 13:23:49 -0800
From: Jason Lunz <lunz@acm.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>,
        atom ota <atomota@sleepyhammer.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        Jeff Dike <jdike@addtoit.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, Rob Landley <rob@landley.net>
Subject: Re: [PATCH] mtd: allow mtd and jffs2 when ARCH=um
Message-ID: <20101214212349.GA6937@falooley.org>
References: <20071024011712.GA3762@falooley.org>
 <1193208689.26096.48.camel@pmac.infradead.org>
 <20071227181524.GA19051@falooley.org>
 <20071228174853.GA4252@uranus.ravnborg.org>
 <20101207072919.GA8511@falooley.org>
 <AANLkTineLxHdcDKZEUGiqVNAauSX_xyQrs49kKaqhiWo@mail.gmail.com>
 <20101207182012.GA10546@falooley.org>
 <1292343878.2538.80.camel@localhost>
 <20101214195124.GA6010@falooley.org>
 <1292356893.29257.1.camel@koala>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292356893.29257.1.camel@koala>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On one hand you've got uml, which simply doesn't have mmio. On the other
there's mtd, which began as a method for accessing hardware devices that
are often accessed using mmio. But then the mtd subsystem developed
emulations of that hardware that are software based and thus don't
require mmio. It's mainly these emulated backends I'm interested in
exposing.

Nothing is going to change so that it makes sense to have any real
mmio-using hardware driver run on uml. The question you raise is, are
there other classes of driver with a software-only subset that can be
exposed on uml? And if so, would adding stub implementations of
readb/writeb and friends actually be enough to make those work? I'm not
aware of any, so at present I don't think the argument for implementing
this in uml arch code is very strong. Or in other words, I don't think a
"general solution" would be very general.

Jason

On Tue, Dec 14, 2010 at 10:01:33PM +0200, Artem Bityutskiy wrote:
> This problem does not seem to be mtd-specific, right? So my point was
> that it would be nicer to come up with a general solution.
