Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab0LBAOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 19:14:38 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42194 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab0LBAOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 19:14:37 -0500
Subject: Re: [PATCH] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for clock
 changes
From: john stultz <johnstul@us.ibm.com>
To: Alexander Shishkin <virtuoso@slind.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>, Feng Tang <feng.tang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        Lennart Poettering <mzxreary@0pointer.de>, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
In-Reply-To: <1291167587-16695-1-git-send-email-virtuoso@slind.org>
References: <1291167587-16695-1-git-send-email-virtuoso@slind.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 16:14:27 -0800
Message-ID: <1291248867.2846.37.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 03:39 +0200, Alexander Shishkin wrote:
> To use this notification functionality, user has to call timerfd_settime()
> with TFD_NOTIFY_CLOCK_SET flag. After this CLOCK_REALTIME timers will
> read as the number of times the wall clock has been set since last read
> and poll every time the wall clock is set; CLOCK_MONOTONIC timers will
> behave likewise, but in the event of the clock being updated upon resuming
> from suspend. For both CLOCK_REALTIME and CLOCK_MONOTONIC timers with
> TFD_NOTIFY_CLOCK_SET flag set, a call to timerfd_gettime() will return
> current wall clock in it_value.

The CLOCK_MONOTONIC flag on resume worries me a bit (since
CLOCK_MONOTONIC isn't adjusted on resume).

What is the use case there?

thanks
-john


