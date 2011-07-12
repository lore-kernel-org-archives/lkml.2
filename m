Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab1GLG5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 02:57:40 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62266 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1GLG5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 02:57:39 -0400
MIME-Version: 1.0
In-Reply-To: <20110708091713.GF2414@n2100.arm.linux.org.uk>
References: <1310104763-12948-1-git-send-email-tommy.lin@caviumnetworks.com>
	<20110708091014.GA15142@oksana.dev.rtsoft.ru>
	<20110708091713.GF2414@n2100.arm.linux.org.uk>
Date: Tue, 12 Jul 2011 14:57:38 +0800
Message-ID: <CAB8eogcYUSYPBS9UAv29MqnTLdUrbYt+y=yLmzG0r92kz-PUXA@mail.gmail.com>
Subject: Re: [PATCH 1/2] arch: arm: Correct the dependency of HAVE_ARM_TWD
From: =?Big5?B?qkynu6Tl?= <tommy.lin.1101@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/8 Russell King - ARM Linux <linux@arm.linux.org.uk>
>
> On Fri, Jul 08, 2011 at 01:10:14PM +0400, Anton Vorontsov wrote:
> > On Fri, Jul 08, 2011 at 01:59:23PM +0800, Tommy Lin wrote:
> > Russell,
> >
> > As the patch is needed for CNS3xxx Watchdog support, I'd like to take
> > it via CNS3xxx tree, if you're OK with that.
>
> No.
>
> TWD is only useful if SMP is enabled, otherwise the contained code
> won't be called.  Without SMP you'll find that the timer rate will
> be zero.
>
> So actually your problems are bigger than just this dependency.
I think LOCAL_TIMERS is the one that useful if SMP is enabled. The zero
timer rate issue still able to limited by LOCAL_TIMERS.
MPCore watchdog is rely on HAVE_ARM_TWD, but not related to SMP
at least in the current source. I have test the watchdog part without enable
SMP and watchdog works well except wrong reload value that can be fixed
by another patch.

--
Best Regards,
Tommy Lin
