Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab2AQV0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 16:26:45 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39037 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755556Ab2AQV0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 16:26:43 -0500
X-Sasl-enc: YFg2U+7wPdmQFvVcxJ6tYpvV1tUxWTLASDjoBrVSa4gm 1326835602
Date: Tue, 17 Jan 2012 13:26:39 -0800
From: Greg Kroah-Hartman <greg@kroah.com>
To: James Bottomley <jbottomley@parallels.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fix compile breakage with kref.h
Message-ID: <20120117212639.GA17297@kroah.com>
References: <1326834845.3020.36.camel@dabdike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326834845.3020.36.camel@dabdike>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 09:14:05PM +0000, James Bottomley wrote:
> This set of build failures just started appearing on parisc:
> 
> In file included from drivers/input/serio/serio_raw.c:12:
> include/linux/kref.h: In function 'kref_get':
> include/linux/kref.h:40: error: 'TAINT_WARN' undeclared (first use in this function)
> include/linux/kref.h:40: error: (Each undeclared identifier is reported only once
> include/linux/kref.h:40: error: for each function it appears in.)
> include/linux/kref.h: In function 'kref_sub':
> include/linux/kref.h:65: error: 'TAINT_WARN' undeclared (first use in this function)
> 
> It happens because TAINT_WARN is defined in kernel.h and this particular
> compile doesn't seem to include it (no idea why it's just
> manifesting ... probably some #include file untangling exposed it).  Fix
> by adding #include <linux/kernel.h> to linux/kref.h

Does adding <linux/bug.h> fix it instead?  We are using WARN_ON() here.
Hm, but that needs kernel.h as well, ugh, what a mess.

> Signed-off-by: James Bottomley <JBottomley@Parallels.com>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

