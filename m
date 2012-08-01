Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab2HAVEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 17:04:48 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:58226 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab2HAVEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 17:04:46 -0400
Date: Wed, 1 Aug 2012 14:02:31 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Colin Cross <ccross@android.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH 03/11] kdb: Implement disable_nmi command
Message-ID: <20120801210231.GC20714@lizard>
References: <20120730115719.GA5742@lizard>
 <1343649500-18491-3-git-send-email-anton.vorontsov@linaro.org>
 <CAMbhsRS1cOf1T8k7K6CFmRA7M52AGPZ2TqmEnpZqDGYnbyetbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMbhsRS1cOf1T8k7K6CFmRA7M52AGPZ2TqmEnpZqDGYnbyetbw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 10:33:34AM -0700, Colin Cross wrote:
> On Mon, Jul 30, 2012 at 4:58 AM, Anton Vorontsov
> <anton.vorontsov@linaro.org> wrote:
> > This command disables NMI-entry. If NMI source was previously shared with
> > a serial console ("debug port"), this effectively releases the port from
> > KDB exclusive use, and makes the console available for normal use.
> >
> > Of course, NMI can be reenabled, enable_nmi modparam is used for that:
> >
> >         echo 1 > /sys/module/kdb/parameters/enable_nmi
> 
> This is very different behavior from the FIQ debugger "console"
> command you are trying to replace.  In the FIQ debugger, everything
> goes through the FIQ/NMI, even when in console mode.  That means that
> the user can always get back to FIQ debugger/KDB mode using a special
> sequence (we use a break character).  With your implementation, if you
> switch from KDB to console to see if the console is working, and find
> that it is not working, you can never get back into KDB.

Ah, I see. But with disable_nmi, in addition to kernel console,
applications can use /dev/ttyXX as normal, and with 'console' command
that is not possible (at least w/o modifying applications to escape
magic sequence). So, I think we should have both commands, each would
handle its own use case.

(Initially I just tried to avoid adding another console driver, but
it seems there is no other way, heh.)

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
