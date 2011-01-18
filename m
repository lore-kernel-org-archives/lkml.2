Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab1ARAgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 19:36:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35614
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752868Ab1ARAgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 19:36:36 -0500
Date: Mon, 17 Jan 2011 16:37:09 -0800 (PST)
Message-Id: <20110117.163709.15244083.davem@davemloft.net>
To: richm@oldelvet.org.uk
Cc: 609371@bugs.debian.org, ben@decadent.org.uk, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, Jesper.Nilsson@axis.com, jeffm@suse.com
Subject: Re: R_SPARC_13
From: David Miller <davem@davemloft.net>
In-Reply-To: <1295307243.32152.106.camel@duncow>
References: <1295293581.32152.70.camel@duncow>
	<20110117.130238.245404805.davem@davemloft.net>
	<1295307243.32152.106.camel@duncow>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Mortimer <richm@oldelvet.org.uk>
Date: Mon, 17 Jan 2011 23:34:03 +0000

> I guess that points towards the binutils linker not doing the correct
> thing.

Ok, it is in fact doing the correct thing.

I'm really surprised we never hit this before in all of these years
:-) I guess we've simply never hit this kind of expression in a module
before.

The issue is that modules aren't a "final link", it's really more like
an intermediate partial link.

So we do end up seeing the R_SPARC_LO10 + R_SPARC_13 sequences in the
final module object.

Therefore, we really should handle R_SPARC_13 in the sparc module loader.

Richard, I want you to get full credit for this since you did all of
the dirty work :-) Would you please cons up a formal patch with commit
message and signoff for this and I'll push it around?

Thanks a lot!
