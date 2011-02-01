Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab1BAGVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 01:21:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36236 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab1BAGVF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 01:21:05 -0500
MIME-Version: 1.0
X-Originating-IP: [93.173.165.51]
In-Reply-To: <20110131153831.dca62146.akpm@linux-foundation.org>
References: <1296470024-26854-1-git-send-email-ohad@wizery.com>
 <1296470024-26854-2-git-send-email-ohad@wizery.com> <20110131153831.dca62146.akpm@linux-foundation.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 1 Feb 2011 08:20:13 +0200
Message-ID: <AANLkTik-fgCF_W0-DBE6UVTpjqF6Jf=u7bQYkcweEegQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] drivers: hwspinlock: add framework
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, Suman Anna <s-anna@ti.com>,
        Kevin Hilman <khilman@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Paul Walmsley <paul@pwsan.com>,
        Hari Kanigeri <hari.kanigeri@gmail.com>,
        Simon Que <simonque@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 1, 2011 at 1:38 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> It's a little irritating having two hwspinlock.h's.
> hwspinlock_internal.h wold be a conventional approach.  But it's not a
> big deal.
...

>> +/**
>> + * __hwspin_lock_timeout() - lock an hwspinlock with timeout limit
>> + * @hwlock: the hwspinlock to be locked
>> + * @timeout: timeout value in jiffies
>
> hm, why in jiffies?
>
> The problem here is that lazy programmers will use
>
>        hwspin_lock_timeout(lock, 10, ...)
>
> and their code will work happily with HZ=100 but will explode with HZ=1000.
>
> IOW, this interface *requires* that all callers perform a
> seconds-to-jiffies conversion before calling hwspin_lock_timeout().  So
> why not reduce their effort and their ability to make mistakes by
> defining the API to take seconds?

I considered that, but then decided to use jiffies in order to be
consistent with wait_event_timeout/schedule_timeout (although I don't
return the remaining jiffies in case the lock is taken before the
timeout elapses), and also to allow user-selected granularity.

But I do kind of like the idea of not using jiffies. We can probably
even move to msecs, since anyway this is an error condition, and
people who needs a quick check should just use the trylock() version.

I'll do a quick respin of the patches with that and the
hwspinlock_internal.h comment above.

Thanks,
Ohad.
