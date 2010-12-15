Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab0LOBTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 20:19:44 -0500
Received: from smtp.falooley.org ([66.180.170.91]:56693 "EHLO
	smtp.falooley.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344Ab0LOBTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 20:19:43 -0500
Date: Tue, 14 Dec 2010 17:19:05 -0800
From: Jason Lunz <lunz@acm.org>
To: Rob Landley <rob@landley.net>
Cc: dedekind1@gmail.com,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>,
        atom ota <atomota@sleepyhammer.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        Jeff Dike <jdike@addtoit.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH] mtd: allow mtd and jffs2 when ARCH=um
Message-ID: <20101215011904.GA24292@falooley.org>
References: <22c797d00709272118i33d32b9dy93d5f5ec8f8edd30@mail.gmail.com>
 <20101214195124.GA6010@falooley.org>
 <1292356893.29257.1.camel@koala>
 <201012141849.03926.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012141849.03926.rob@landley.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 06:49:02PM -0600, Rob Landley wrote:
> The problem is that jffs2 is a filesystem, and thus something people would 
> really like to be able to loopback mount, but it's hardwired to assume it's 
> only ever stored on a certain type of hardware, and thus requies incestuous 
> knowledge of the erase granularity of the flash layer in order to function.

I assume you can turn your jffs2 image file into a block dev using
losetup, then turn the corresponding loop device into an mtd device
using block2mtd, at which point you ought to be able to mount it with
jffs2. I've never tried it.

> What any of this has to do with UML is an open question.  I don't want to 
> require UML to loopback mount a jffs2 image, I want to be able to do it from my 
> host.  From my perspective, you're solving the wrong problem.

There's more than just loopback-mounting jffs2 images. I use this to
make entire uml+jffs2 virtual machines for testing purposes.

Jason
