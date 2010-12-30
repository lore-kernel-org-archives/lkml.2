Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab0L3O6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 09:58:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50432 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab0L3O6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 09:58:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Evgeniy Dushistov <dushistov@mail.ru>
Subject: Re: [PATCH 0/7] BKL removal follow-up
Date: Thu, 30 Dec 2010 15:58:22 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
References: <1290007619-5787-1-git-send-email-arnd@arndb.de> <201012212354.06895.arnd@arndb.de> <20101224110458.GA18894@maclin>
In-Reply-To: <20101224110458.GA18894@maclin>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012301558.22191.arnd@arndb.de>
X-Provags-ID: V02:K0:5tYLmYu7HCyyKPzCExmBUGMi52Igsqku3dPHykexrXv
 KqSBTNBid3g3L64kwqj8IM8zN3WNK0HfK0EdqaKj0gTPneT9Cz
 Y7B2gOpuZNDpWnRza/9k/Yi6mss2+O5kOKHrktKZINNV9tGh9O
 A8Gy1qMNETDcpUbkjESb41EnVsQWhffVpdGenJ7hsHc7+mLjGP
 Fz11eu5gAlq+XmzeDLMVw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 December 2010, Evgeniy Dushistov wrote:
> On Tue, Dec 21, 2010 at 11:54:06PM +0100, Arnd Bergmann wrote:
> > On Monday 22 November 2010 16:17:23 Nick Bowler wrote:
> > > On 2010-11-21 09:45 -0800, Linus Torvalds wrote:
> > > > Yes, I'd be ok with UDF doing a "select BKL" along with a "default n"
> > > > for BKL itself.
> > > > 
> > > > I think UDF currently is the only sane reason to have BKL enabled any
> > > > more, and yes, it would probably make it easier to configure things.
> > > 
> > > UFS (which I use) also relies on BKL.
> > 
> > Would you mind running a kernel with this patch and lockdep enabled then?
> > 
> > It's quite likely that this doesn't work, but the easiest way to find
> > out is to just try it if you don't understand the code. I can't see anything
> > in the code that relies on the release-on-sleep semantics and there
> > are no obvious recursive lock_kernel() calls.
> 
> I see one without looking at code (am I missed something?). See below.

Right, that was rather obvious, thanks for taking a look!

Now that I have your attention, do you expect to be able to prepare
a proper patch for 2.6.38? I don't have any experience with this file
system, nor do I have useful ways of testing it, so that would be
appreciated. Nick already volunteered to test patches, but I guess it
would make more sense if you could do the patch.

	Arnd
