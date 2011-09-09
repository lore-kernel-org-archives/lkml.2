Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855Ab1IITM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 15:12:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759629Ab1IITM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 15:12:58 -0400
Date: Fri, 9 Sep 2011 15:12:39 -0400
From: Neil Horman <nhorman@redhat.com>
To: Eric Paris <eparis@parisplace.org>
Cc: David Miller <davem@davemloft.net>, sgrubb@redhat.com, hch@infradead.org,
        stephan.mueller@atsec.com, tytso@mit.edu, jarod@redhat.com,
        levinsasha928@gmail.com, linux-crypto@vger.kernel.org, mpm@selenic.com,
        herbert.xu@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] random: add blocking facility to urandom
Message-ID: <20110909191239.GE22810@hmsreliant.think-freely.org>
References: <4E67E1B0.2040309@atsec.com>
 <20110908084420.GC4032@infradead.org>
 <201109080748.27750.sgrubb@redhat.com>
 <20110908.121347.1753630996526838840.davem@davemloft.net>
 <CACLa4ptAYEieckVLz+qs9PGfDrw9QjExUx+EMn9tqiCoQ4aqfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACLa4ptAYEieckVLz+qs9PGfDrw9QjExUx+EMn9tqiCoQ4aqfg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 03:08:03PM -0400, Eric Paris wrote:
> On Thu, Sep 8, 2011 at 12:13 PM, David Miller <davem@davemloft.net> wrote:
> > From: Steve Grubb <sgrubb@redhat.com>
> 
> >> This patch does not _break_ all existing applications. If a system were under attack,
> >> they might pause momentarily, but they do not break. Please, try the patch and use a
> >> nice large number like 2000000 and see for yourself. Right now, everyone arguing about
> >> this breaking things have not tried it to see if in fact things do break and how they
> >> break if they do.
> >
> > If the application holds a critical resource other threads want when it
> > blocks on /dev/urandom, then your change breaks things.  I can come up
> > with more examples if you like.
> >
> > Please get off this idea that you can just change the blocking behavior
> > for a file descriptor and nothing of consequence will happen.
> 
> I know it's work porting userspace, but would anyone think that a new
> char device to do this would be a good enough idea?  You obviously
> already worked out methods to port things which normally use urandom
> to use random to discover the problem, so most of the work should be
> done.  I suggest /dev/jkrandom (since this is half way between
> /dev/random and /dev/urandom and 'u' is the 21st letter it seemed
> appropriate to use letters 10 and 11)
> 
I was going to suggest /dev/sourandom (for sort-of-urandom) :)
Neil

> Thus userspace can decide what matters.  Always with entropy and
> blocks often (random).  From good enough entropy and rarely blocks
> (jkrandom).  Possibly from some entropy and never block (urandom).
> 
> -Eric
