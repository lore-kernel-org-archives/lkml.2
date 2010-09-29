Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab0I2BHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 21:07:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38050 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab0I2BHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 21:07:40 -0400
Date: Wed, 29 Sep 2010 02:07:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Michael Cree <mcree@orcon.net.nz>
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
        mattst88@gmail.com, torvalds@linux-foundation.org
Subject: Re: [PATCH 1/2] alpha: switch osf_sigprocmask() to use of
 sigprocmask()
Message-ID: <20100929010738.GJ19804@ZenIV.linux.org.uk>
References: <E1OzvxM-0002ng-B5@ZenIV.linux.org.uk>
 <4CA1B7DF.10202@orcon.net.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA1B7DF.10202@orcon.net.nz>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 10:39:43PM +1300, Michael Cree wrote:
> On 27/09/10 07:28, Al Viro wrote:
> >
> >get rid of a useless wrapper, while we are at it
> >
> >Signed-off-by: Al Viro<viro@zeniv.linux.org.uk>
> 
> Compiling this leads to the following errors:
> 
> arch/alpha/kernel/signal.c: In function ?SYSC_osf_sigprocmask?:
> arch/alpha/kernel/signal.c:52: error: implicit declaration of
> function ?siprocmask?
> arch/alpha/kernel/signal.c:55: error: invalid type argument of ?->?
> (have ?sigset_t?)
> 
> Obviously it should be sigprocmask at line 52, and presumably line
> 55 which is currently
> 
> 		res = oldmask->sig[0];
> 
> should be
> 
> 		res = oldmask.sig[0];

Grrrr....   My apologies - cherry-pick from the wrong branch ;-/

Al "nothing like seeing the errors one has fixed show up in what's sent" Viro
