Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab0KWWoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 17:44:08 -0500
Received: from tango.0pointer.de ([85.214.72.216]:50982 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab0KWWoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 17:44:07 -0500
Date: Tue, 23 Nov 2010 23:43:46 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Alexander Shishkin <virtuoso@slind.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>, Feng Tang <feng.tang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        John Stultz <johnstul@us.ibm.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] [RFC] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for
 clock changes
Message-ID: <20101123224346.GA19350@tango.0pointer.de>
References: <1290532938-7332-1-git-send-email-virtuoso@slind.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290532938-7332-1-git-send-email-virtuoso@slind.org>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23.11.10 19:22, Alexander Shishkin (virtuoso@slind.org) wrote:

> Certain userspace applications (like "clock" desktop applets or cron or
> systemd) might want to be notified when some other application changes
> the system time. There are several known to me reasons for this:
>  - avoiding periodic wakeups to poll time changes;
>  - rearming CLOCK_REALTIME timers when said changes happen;
>  - changing system timekeeping policy for system-wide time management
>    programs;
>  - keeping guest applications/operating systems running in emulators
>    up to date.
> 
> This is another attempt to approach notifying userspace about system
> clock changes. The other one is using an eventfd and a syscall [1]. In
> the course of discussing the necessity of a syscall for this kind of
> notifications, it was suggested that this functionality can be achieved
> via timers [2] (and timerfd in particular [3]). This idea got quite
> some support [4], [5], [6] and some vague criticism [7], so I decided
> to try and go a bit further with it.

I agree with Kay, this is pretty much exactly what we want for
systemd. (Assuming that the time jump due to system suspend is
propagated to userspace like any other time jump with this path).

So yeah, I'd be very happy if this could be merged.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
