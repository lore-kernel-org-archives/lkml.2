Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759361Ab1CDJ6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 04:58:24 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:49799 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab1CDJ6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 04:58:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Steffen Sledz <sledz@dresearch.de>
Subject: Re: [PATCH resent] tcp: ioctl type SIOCOUTQNSD returns amount of data not sent
Date: Fri, 4 Mar 2011 10:57:53 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc6+; KDE/4.5.1; x86_64; ; )
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        m.schuknecht@dresearch.de
References: <1299228497-21246-1-git-send-email-sledz@dresearch.de> <20110304.010428.71127798.davem@davemloft.net> <4D70B621.7020307@dresearch.de>
In-Reply-To: <4D70B621.7020307@dresearch.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103041057.53671.arnd@arndb.de>
X-Provags-ID: V02:K0:jJYxgqehqQbKKSvFHdP8p3gM7NUcar8vPJTmpZBh85N
 yU9SZal5oGz60KUJVWUN8eUYDSd4xcEXrB5y6eCt9JA3YPjXAQ
 MgO47OicCsiK7grpzorSFQgPAzvEzEyJn4WT58ULBEACopGc0C
 yJm6c5QEc8d4Cj5jYG6um3qHD1sU8eSovzbC3sOo15jVvo2eeY
 Oo8rVelRvtuRvFhMiQ1PA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 March 2011 10:51:29 Steffen Sledz wrote:
> Am 04.03.2011 10:04, schrieb David Miller:

> > Hitting only asm-generic/ioctls.h is insufficient, many architectures do
> > not make use of this file and the build will fail for them with your patch
> > applied.
> 
> That's not fully clear to me.
> 
> We made the define similar to the existing TIOCOUTQ. What other files should be hit?
> 

These ones:

$ git grep TIOCOUTQ arch/*/include/
arch/alpha/include/asm/ioctls.h:#define TIOCOUTQ        _IOR('t', 115, int)     /* output queue size */
arch/mips/include/asm/ioctls.h:#define TIOCOUTQ 0x7472          /* output queue size */
arch/parisc/include/asm/ioctls.h:#define TIOCOUTQ       0x5411
arch/powerpc/include/asm/ioctls.h:#define TIOCOUTQ        _IOR('t', 115, int)     /* output queue size */
arch/sh/include/asm/ioctls.h:#define TIOCOUTQ        _IOR('t', 115, int)     /* output queue size */
arch/sparc/include/asm/ioctls.h:#define TIOCOUTQ        _IOR('t', 115, int)
arch/xtensa/include/asm/ioctls.h:#define TIOCOUTQ        _IOR('t', 115, int)     /* output queue size */

	Arnd
