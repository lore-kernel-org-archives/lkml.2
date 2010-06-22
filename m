Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab0FVMKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 08:10:17 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35823 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755771Ab0FVMKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 08:10:15 -0400
Subject: Re: [PATCH] kmemleak: config-options: Default buffer size for
 kmemleak
From: Catalin Marinas <catalin.marinas@arm.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Sankar P <sankar.curiosity@gmail.com>, penberg@cs.helsinki.fi,
       linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
       lrodriguez@atheros.com, rnagarajan@novell.com, teheo@novell.com,
       linux-mm@kvack.org, paulmck@linux.vnet.ibm.com, mingo@elte.hu,
       akpm@linux-foundation.org
In-Reply-To: <20100622113135.GB20140@linux-sh.org>
References: <AANLkTimb7rP0rS0OU8nan5uNEhHx_kEYL99ImZ3c8o0D@mail.gmail.com>
	 <1277189909-16376-1-git-send-email-sankar.curiosity@gmail.com>
	 <4C20702C.1080405@cs.helsinki.fi>
	 <1277196403-20836-1-git-send-email-sankar.curiosity@gmail.com>
	 <20100622113135.GB20140@linux-sh.org>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Tue, 22 Jun 2010 13:05:51 +0100
Message-ID: <1277208351.29532.5.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jun 2010 12:05:52.0643 (UTC) FILETIME=[42E0ED30:01CB1203]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 12:31 +0100, Paul Mundt wrote:
> On Tue, Jun 22, 2010 at 02:16:43PM +0530, Sankar P wrote:
> > If we try to find the memory leaks in kernel that is
> > compiled with 'make defconfig', the default buffer size
> > of DEBUG_KMEMLEAK_EARLY_LOG_SIZE seem to be inadequate.
> >
> > Change the buffer size from 400 to 1000,
> > which is sufficient for most cases.
> >
> Or you could just bump it up in your config where you seem to be hitting
> this problem. The default of 400 is sufficient for most people, so
> bloating it up for a corner case seems a bit premature. Perhaps
> eventually we'll have no choice and have to tolerate the bloat, as we did
> with LOG_BUF_SHIFT, but it's not obvious that we've hit that point with
> kmemleak yet.

I agree. The 400 seems to be sufficient with standard kernel
configurations (I usually try some of the Ubuntu configs on x86). The
error message is hopefully clear enough about what needs to be changed.

The defconfig change for this specific platform may be a better option
but I thought defconfigs are to provide a stable (and maybe close to
optimal) configuration without all the debugging features enabled
(especially those slowing things down considerably).

-- 
Catalin

