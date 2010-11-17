Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab0KQFxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 00:53:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751105Ab0KQFxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 00:53:00 -0500
MIME-Version: 1.0
In-Reply-To: <20101117032721.GA8630@redhat.com>
References: <20101117032721.GA8630@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 16 Nov 2010 21:52:12 -0800
Message-ID: <AANLkTi=MLowxVT2BoXuA9r8EnYDWPNTYyMP9AhHseznB@mail.gmail.com>
Subject: Re: failure to boot any kernel since 2.6.36rc6-git2.
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 7:27 PM, Dave Jones <davej@redhat.com> wrote:
> Every kernel between 2.6.36-rc6 and 2.6.37rc2 fails to boot on my laptop.
> The -git's that followed -rc6 had a fairly large (considering rc6) acpi merge,
> which I suspected was the cause.

You have marked (for example) commit 77f890223338 as bad, but that's
way before the ACPI merge.

So there's something wrong with your bisect. When you marked c9d66d35
as bad, that is literally _exactly_ v2.6.36-rc6 plus one mfd commit.
So if that kernel doesnt' boot for you, then neither will plain
2.6.36-rc6.

I see a few possibilities:

 - you somehow tested/booted the wrong kernels and thus marked things
"bad" when they weren't.

 - 2.6.36-rc6 doesn't work either, so you started out saying it was
good even though it wasn't really. Everything after it is obviously
also broken, so you'll just end up with everything marked "bad", and
bisection will decide it must be the first commit after 2.6.36-rc6
(since that was marked "good").

 - there's some bug that affects boot of the "next" kernel, and the
kernel you go back to in between has that problem.

 - you switched compiler or other build tool in between things, so
back when you started, 2.6.36-rc6 was good, but then when you compiled
that same kernel with the trivial mfd thing on top, the build tool
change resulted in it no longer working - but not having anything to
do with the actual kernel sources in question.

So double-check that 2.6.36-rc6 kernel.

                 Linus
