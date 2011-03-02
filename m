Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab1CBPsw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 10:48:52 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:35069 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750959Ab1CBPsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 10:48:51 -0500
Date: Wed, 2 Mar 2011 10:48:42 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Evgeniy Dushistov <dushistov@mail.ru>,
        Nick Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 4/7] ufs: remove the BKL
Message-ID: <20110302154842.GA32314@elliptictech.com>
References: <1299021191-17961-1-git-send-email-arnd@arndb.de>
 <1299021191-17961-5-git-send-email-arnd@arndb.de>
 <20110302144705.GA15482@elliptictech.com>
 <201103021608.31875.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103021608.31875.arnd@arndb.de>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-02 16:08 +0100, Arnd Bergmann wrote:
> On Wednesday 02 March 2011, Nick Bowler wrote:
> > On 2011-03-02 00:13 +0100, Arnd Bergmann wrote:
> > > The code is still only compile-tested,
> > 
> > This isn't true anymore; I've been running with this patch (well, the
> > previous versions thereof) for some time now.  On the other hand, I
> > don't use all of this driver's features.
> 
> I'll updated the comment. Can I add your Tested-by tag?

Sure.

> > > but it should at least be harmless on non-SMP systems, since the new
> > > mutex is not taken on those.
> > 
> > I think this part of the patch is strange.  It seems like a gratuitous
> > difference between SMP/preempt and other systems to #if out the code
> > that takes the mutex.  This might make problems with the conversion fly
> > under the radar longer because people with older systems won't encounter
> > them.
> 
> I agree it is strange, but the mutex has some serious performance impact
> that I wanted to minimize on the systems where we know it is not needed.
> The BKL was only active on those systems, so we know that non-SMP
> non-preempt kernels don't need the mutex.

Fair enough.  If it hurts too much to run this code when it's not
needed, then I guess it makes sense to leave it out.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
