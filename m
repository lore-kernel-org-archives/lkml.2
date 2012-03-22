Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965017Ab2CVTKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 15:10:52 -0400
Received: from mail.windriver.com ([147.11.1.11]:44095 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759315Ab2CVTKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 15:10:50 -0400
Date: Thu, 22 Mar 2012 14:10:05 -0500
From: Peter Seebach <peter.seebach@windriver.com>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
CC: "ext H. Peter Anvin" <hpa@zytor.com>, Jiri Slaby <jslaby@suse.cz>,
        <apw@canonical.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] checkpatch.pl: thou shalt not use () or (...) in
 function declarations
Message-ID: <20120322141005.1abe7b1e@wrlaptop>
In-Reply-To: <20120322174802.GE19970@pcarmody2.research.nokia.com>
References: <1332430038-21057-1-git-send-email-ext-phil.2.carmody@nokia.com>
	<4F6B51C9.6010904@suse.cz>
	<4F6B5902.1080607@zytor.com>
	<20120322174802.GE19970@pcarmody2.research.nokia.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2012 19:48:02 +0200
Phil Carmody <ext-phil.2.carmody@nokia.com> wrote:

> While empty paramter lists in function definitions are not technically
> wrong, those situations are rare enough that it's worth encouraging
> people towards a more uniform, always unambiguous, style.

Typo here ("paramter").

You don't need to check for (...).  That doesn't actually exist, and
gcc rejects it (as it should).  The description of () as meaning (...)
is a (slight) oversimplification.  As to the () case:

The rules here are complicated.  Complicated enough that I don't even
TRY to remember them.  Fundamentally, f() is equivalent to either
f(void) or f(please do unpleasant things to me with railroad spikes).
I would definitely endorse a policy discouraging its use.

I can only think of one exception, and it's inapplicable.  The
exception:  Imagine that you wish to write a wrapper for a function
like scandir, which takes a function pointer as an argument, and you
wish the wrapper to work on two systems where the arguments passed to
the function pointer are of different types, but you yourself will
never actually see or care about the arguments; you just want to pass
the function pointer around.  Then it could make sense to declare the
argument as int (*compar)().  But that's a once-a-lifetime use case,
give or take.

-s
-- 
Listen, get this.  Nobody with a good compiler needs to be justified.
