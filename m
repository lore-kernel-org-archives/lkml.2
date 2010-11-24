Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab0KXIGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:06:09 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64338 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab0KXIGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:06:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nyWwQY/iLodXiFFwaejyyCHs6F2ARPajC2Gao6f0ItnWmOpdcTEepbzRSHsMCGJnPm
         0HxaiGHUcnwHgZAuzMCOk0shDFKKJkU2CKTA51wXoQYeE1p9XJDtJxp4L6/WIYAt18p3
         QvVJFWFgstjyvyHExKT9uWBhVg5NGhwn2dqIU=
Subject: Re: [PATCH] [RFC] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for
 clock changes
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>, Feng Tang <feng.tang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        John Stultz <johnstul@us.ibm.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Davide Libenzi <davidel@xmailserver.org>,
        linux-fsdevel@vger.kernel.org
In-Reply-To: <20101123224346.GA19350@tango.0pointer.de>
References: <1290532938-7332-1-git-send-email-virtuoso@slind.org>
	 <20101123224346.GA19350@tango.0pointer.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Nov 2010 10:05:35 +0200
Message-ID: <1290585935.2438.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 23:43 +0100, Lennart Poettering wrote:
> On Tue, 23.11.10 19:22, Alexander Shishkin (virtuoso@slind.org) wrote:
> 
> > Certain userspace applications (like "clock" desktop applets or cron or
> > systemd) might want to be notified when some other application changes
> > the system time. There are several known to me reasons for this:
> >  - avoiding periodic wakeups to poll time changes;
> >  - rearming CLOCK_REALTIME timers when said changes happen;
> >  - changing system timekeeping policy for system-wide time management
> >    programs;
> >  - keeping guest applications/operating systems running in emulators
> >    up to date.
> > 
> > This is another attempt to approach notifying userspace about system
> > clock changes. The other one is using an eventfd and a syscall [1]. In
> > the course of discussing the necessity of a syscall for this kind of
> > notifications, it was suggested that this functionality can be achieved
> > via timers [2] (and timerfd in particular [3]). This idea got quite
> > some support [4], [5], [6] and some vague criticism [7], so I decided
> > to try and go a bit further with it.
> 
> I agree with Kay, this is pretty much exactly what we want for
> systemd. (Assuming that the time jump due to system suspend is
> propagated to userspace like any other time jump with this path).

A "Tested-by: Lennart Poettering <mzxreary@0pointer.de>" would be
helpful, I think.

> So yeah, I'd be very happy if this could be merged.

Hmm, and question about why exactly the timerfd interface is a bad way
to go was ignored.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

