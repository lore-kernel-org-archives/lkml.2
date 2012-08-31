Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180Ab2HaE0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 00:26:32 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48203 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab2HaE0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 00:26:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120831040500.GA6090@amos.fritz.box>
References: <20120831040500.GA6090@amos.fritz.box>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 30 Aug 2012 21:25:52 -0700
X-Google-Sender-Auth: nMvHBHEPsjzOhBakqulNmo15EOM
Message-ID: <CA+55aFxuruMmrhgz9OGZcxyJ_tSp5rj9gSfxTYkjirSO7nvoxQ@mail.gmail.com>
Subject: Re: [REGRESSION] Xorg doesn't like 4e8b14526 "time: Improve sanity
 checking of timekeeping inputs"
To: Andreas Bombe <aeb@debian.org>
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 9:05 PM, Andreas Bombe <aeb@debian.org> wrote:
>
> With that somewhat easy test I bisected it down to 4e8b14526 "time:
> Improve sanity checking of timekeeping inputs". The latest Linus git
> (155e36d40) with a revert of the bisected commit does not show the
> problem.

Ok, I guess we need to revert it. Although it might be interesting to
add a WARN_ON_ONCE() for the case of timespec_valid() returning false,
to just see exactly *where* that thing triggers. Could you do that? In
fact, do it with separate WARN_ON_ONCE's for each of the reasons that
function returns false, so that we also see which check it is that
triggers. Ok?

            Linus
