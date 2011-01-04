Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317Ab1ADMXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 07:23:43 -0500
Received: from mail-iw0-f194.google.com ([209.85.214.194]:52757 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab1ADMXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 07:23:41 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.227.56]
In-Reply-To: <20101218005311.GE5941@atomide.com>
References: <1291420247-18171-1-git-send-email-ohad@wizery.com>
 <AANLkTin1fd=Kei7Fo6G+uR+270HdTkc71fvsA6qjBjcA@mail.gmail.com>
 <20101214170656.GA3832@kroah.com> <AANLkTi=q=QMQ_Abxb8eUWT_qGG8K=pc892ZB-mqgt_mh@mail.gmail.com>
 <20101216210837.GA22895@kroah.com> <AANLkTi=s_Urcin4SAp1mXrKmoyzR2=6YuS3aU+OYYgqK@mail.gmail.com>
 <20101218005311.GE5941@atomide.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 4 Jan 2011 14:23:20 +0200
Message-ID: <AANLkTikLuu+njQA_PRmS_q8zs_xpB2gsqh3oZQJkB_Cm@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] Introduce hardware spinlock framework
To: akpm@linux-foundation.org
Cc: Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Sat, Dec 18, 2010 at 2:53 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Ohad Ben-Cohen <ohad@wizery.com> [101216 13:34]:
>> Tony, Andrew, can you please have a look ?
>>
>> Any comment or suggestion is appreciated.
>
> Looks sane to me from omap point of view and it seems the locks
> are now all timeout based:
>
> Acked-by: Tony Lindgren <tony@atomide.com>

Can you please have a look at this patch set (see link no. [1] below) ?

Short summary:

This hwspinlock framework adds support for hardware-based locking
devices, needed to accomplish synchronization and mutual exclusion
operations between remote processors that have no alternative
mechanism to do so.

This patch set adds a framework and an OMAP implementation. It had
circulated several times in the relevant mailing lists, and all
comments were addressed. The third version of this patch set [1] was
submitted about a month ago and so far there is no outstanding
comment.

Users for this framework that we are aware of:

1. OMAP4 and Davinci Netra (DM8168): both of these SoC have the same
hwspinlock module and will share the same host implementation.

2. Other platforms (such as omap3530 and omapl1xx) that have no such
hardware support, but would still need to achieve synchronization (to
communicate with their DSP).

The only way to achieve mutual exclusion on those platforms is by
using a shared-memory synchronization algorithm called Peterson's
Algorithm [2].

We would still need the same hwspinlock framework for that - the busy
looping, the timeout, the various locking schemes, the lock resource
allocation - are all still valid. The only difference would be the
actual lock implementation, therefore we will add another host
implementation
for these platforms.

3. The C6474, a multi-core DSP device [3], have Linux running on one
of its cores, and hardware support for synchronization (btw the C6474
has a richer hardware module that would need more than the hwspinlock
framework offer today - it also supports queuing, owner semantics and
interrupt notification to let a processor know when it acquires a
lock, so it wouldn't have to spin..).  Disclaimer: it will probably
take some time until c6x support is merged upstream, but this is
something that is being actively worked on [4].


Any comment or suggestion is appreciated.

Thanks,
Ohad.

[1] http://www.mail-archive.com/linux-omap@vger.kernel.org/msg39833.html
[2] http://en.wikipedia.org/wiki/Peterson's_algorithm
[3] http://focus.ti.com/docs/prod/folders/print/tms320c6474.html
[4] http://www.linux-c6x.org/wiki/index.php/Main_Page
