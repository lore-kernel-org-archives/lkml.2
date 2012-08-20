Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab2HTUvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 16:51:38 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56539 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab2HTUvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 16:51:35 -0400
MIME-Version: 1.0
In-Reply-To: <20120820144449.GA32560@lizard>
References: <20120820144449.GA32560@lizard>
Date: Mon, 20 Aug 2012 13:51:33 -0700
Message-ID: <CANqkERCzQdViRjhtz19wbSWEEnxYjpDcuUZNP9jNHYrtANwp-g@mail.gmail.com>
Subject: Re: [PATCH v4 0/12] KGDB/KDB FIQ (NMI) debugger
From: Brian Swetland <swetland@google.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Colin Cross <ccross@android.com>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com, kgdb-bugreport@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 7:44 AM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
>
> - KGDB/KDB FIQ debugger shell is synchronous. In Google's version you
>   could have a dedicated shell always running in the FIQ context, so
>   when you type something on a serial line, you won't actually cause any
>   debugging actions, FIQ would save the characters in its own buffer and
>   continue execution normally. But when you hit return key after the
>   command, then the command is executed.
>
>   In KGDB/KDB FIQ debugger it is different. Once you enter KGDB, the
>   kernel will stop until you instruct it to continue.
>
>   This might look as a drastic change, but it is not. There is actually
>   no difference whether you have sync or async shell, or at least I
>   couldn't find any use-case where this would matter at all. Anyways, it
>   is still possible to do async shell in KDB, just don't see any need
>   for this.

The main reason we did this asynchronously was that it's entirely possible
to get the occasional random character on the debug serial port (which is
often multiplexed with the audio path on the headphone jack), and having
the device freeze mysteriously when this happens is problematic.

Since the FIQ debugger is incredibly useful for diagnosing "my device is
stuck" type problems, we tend to leave it enabled on large numbers of
devices during internal testing, so that if somebody runs into a problem
an engineer can plug in a serial debug cable and take a look.  It's
important that the presence of the debug feature doesn't lead to instability,
and thus we don't want a single random character to stop the normal
operation ofthe device.

Brian
