Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab2DDO3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 10:29:34 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35818 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756415Ab2DDO3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 10:29:32 -0400
Date: Wed, 4 Apr 2012 16:29:24 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Fabio Estevam <festevam@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, linux@arm.linux.org.uk, sam@ravnborg.org,
        Fabio Estevam <fabio.estevam@freescale.com>, kernel@pengutronix.de
Subject: Re: [PATCH v2] compiler.h: Include <linux/bug.h> to avoid build
 breakage with ARRAY_SIZE()
Message-ID: <20120404142924.GA15647@pengutronix.de>
References: <1330436499-17190-1-git-send-email-fabio.estevam@freescale.com>
 <1330650922-24143-1-git-send-email-festevam@gmail.com>
 <CAP=VYLpd5EFmD+8Yo_jm-9N7O5zkLTsTwGjgmxG4u_G6t=4fag@mail.gmail.com>
 <4F50D78A.1020209@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F50D78A.1020209@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Mar 02, 2012 at 09:22:02AM -0500, Paul Gortmaker wrote:
> On 12-03-01 10:13 PM, Fabio Estevam wrote:
> > On Thu, Mar 1, 2012 at 11:49 PM, Paul Gortmaker
> > <paul.gortmaker@windriver.com> wrote:
> > 
> >> Thanks, but no.
> >>
> >> You missed the whole point of my previous comments -- that being
> >> that we don't want to just jam headers into always-used headers.
> > 
> > Yes, it is not clear for me how to fix this build error. I got
> > different feedbacks from you, Russell and Sam.
> 
> Understood, there was some discussion there.  Anyways it is already
> dealt with in yesterday's linux-next tree, so you won't have the
> build failure anymore.
I hit that same problem in an not yet mainlined source file. A simple
file containing only:

	#include <linux/kernel.h>

	int array[3];

	int func(void)
	{
		return ARRAY_SIZE(array);
	}

fails to build on top of v3.4-rc1. Am I right that you saying "you won't
have the build failure anymore" means that each of these is now needed
to be fixed individually by adding

	#include <linux/bug.h>

? Otherwise it's not fixed for me.

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
