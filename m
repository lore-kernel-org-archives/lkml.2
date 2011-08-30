Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751193Ab1H3CtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 22:49:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59131 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab1H3CtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 22:49:02 -0400
Date: Tue, 30 Aug 2011 03:48:53 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net,
        Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH 8/9] um: fix strrchr problems
Message-ID: <20110830024853.GS2203@ZenIV.linux.org.uk>
References: <1314634419-24766-1-git-send-email-richard@nod.at>
 <1314634419-24766-9-git-send-email-richard@nod.at>
 <20110829142705.5be82d7c.akpm@linux-foundation.org>
 <4E5C06DF.60508@nod.at>
 <20110829221230.GP2203@ZenIV.linux.org.uk>
 <4E5C0F9F.5000405@nod.at>
 <20110829221922.GQ2203@ZenIV.linux.org.uk>
 <4E5C11D5.4020404@nod.at>
 <20110830002330.GR2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110830002330.GR2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 01:23:31AM +0100, Al Viro wrote:
> On Tue, Aug 30, 2011 at 12:25:25AM +0200, Richard Weinberger wrote:
> 
> > I'm building most of the time static.
> > Using defconfig and
> > CONFIG_STATIC_LINK=y
> > it builds fine here (x86_64 and i386)
> 
> 32bit build works, 64bit one breaks with
> 
> /usr/lib/gcc/x86_64-linux-gnu/4.4.5/../../../../lib/libc.a(strrchr.o): In function `rindex':
> (.text+0x0): multiple definition of `strrchr'
> 
> on squeeze/amd64 with stock toolchain and libc (2.11.2-10).  .config, if
> you care, is as below, but I really suspect that most of that is irrelevant.

As the matter of fact, on the same build system defconfig + STATIC_LINK +
UML_NET_VDE is enough to reproduce it.

Toolchain:
	libc6		2.11.2-10
	vde2		2.2.3-3
	gcc		4.4.5-8
	binutils	2.20.1-16

all from stock stable/amd64.  Note that debian has the original of that
patch in their user-mode-linux package; see http://bugs.debian.org/494995
for history.
