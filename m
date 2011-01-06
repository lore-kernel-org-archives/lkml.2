Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab1AFPpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 10:45:52 -0500
Received: from canuck.infradead.org ([134.117.69.58]:49382 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab1AFPpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 10:45:50 -0500
Subject: Re: [PATCH] mtd: allow mtd and jffs2 when ARCH=um
From: David Woodhouse <dwmw2@infradead.org>
To: Jason Lunz <lunz@acm.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>, atom ota <atomota@sleepyhammer.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        Jeff Dike <jdike@addtoit.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, Rob Landley <rob@landley.net>
Date: Thu, 06 Jan 2011 15:45:34 +0000
In-Reply-To: <20101214195124.GA6010@falooley.org>
References: <22c797d00709272118i33d32b9dy93d5f5ec8f8edd30@mail.gmail.com>
	 <20071024011712.GA3762@falooley.org>
	 <1193208689.26096.48.camel@pmac.infradead.org>
	 <20071227181524.GA19051@falooley.org>
	 <20071228174853.GA4252@uranus.ravnborg.org>
	 <20101207072919.GA8511@falooley.org>
	 <AANLkTineLxHdcDKZEUGiqVNAauSX_xyQrs49kKaqhiWo@mail.gmail.com>
	 <20101207182012.GA10546@falooley.org> <1292343878.2538.80.camel@localhost>
	 <20101214195124.GA6010@falooley.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.5 
Content-Transfer-Encoding: 7bit
Message-ID: <1294328738.20779.10.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-14 at 11:51 -0800, Jason Lunz wrote:
> 
> > Instead, you should solve this problem in UML code. I do not know how,
> > but may be you can add readb/writeb there which actually do nothing or
> > print a scary warning, or do BUG(), and let things which use them just
> > fail run-time.
> 
> Something like this could work, but it would be error-prone for anyone
> else who attempts using iomem-requiring drivers on uml. Instead of
> getting obvious compile failures we'd have broken drivers that BUG() or
> emit scary warnings. That doesn't seem to me like an improvement. 

Drivers should *never* BUG() or crash, or busy-loop, on getting 0xFF
when they read from hardware. That can happen anyway in some
circumstances.

Doesn't iSeries take this approach?

I don't much like the patch that Artem took into his l2-mtd tree; it
doesn't even let you build mtdchar, which really *ought* to be
permitted. It also didn't allow the nandsim or mtdram devices, which are
purely virtual.

I think I'd prefer something similar to your original, Jason. I don't
think the HAS_IOMEM dependencies have to be *so* complex to maintain. If
anything we're just going to err on the side of inclusion and you'll
occasionally have to send us patches to "hide" things from you again.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

