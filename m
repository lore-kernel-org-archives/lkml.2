Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab0HYXzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 19:55:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58989 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab0HYXzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 19:55:14 -0400
Message-ID: <4C75AD28.8060101@zytor.com>
Date: Wed, 25 Aug 2010 16:54:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: RFC: remove or modify check_for_bios_corruption()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

check_for_bios_corruption() was added to discover how many systems have
BIOSes with problems corrupting low memory.  The answer really is very
simple... almost all.  In fact, I have seen claims that Windows 7
doesn't use any memory below the 1 MiB point at all for this reason.

As such, I have queued up a patch in -tip to reserve the low 64K for all
BIOSes, with an option (suggested by Andrew) to adjust the reservation
further.

Since checking for corruption makes the memory unavailable anyway and
since it is now established the memory is too unreliable to use, I am
suggesting removing the check code completely.

The other alternative is to have it optionally scan from the reserved
threshold to some higher point, and only kick in if that gap is nonzero.
 That way it doesn't continually run for most users, but it might be
useful to confirm corruption if we explicitly suspect it on some system.

Thoughts?

	-hpa
