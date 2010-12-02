Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab0LBB4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 20:56:12 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:48777 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab0LBB4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 20:56:10 -0500
Subject: Re: [PATCH] [RFC] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for
 clock changes
From: john stultz <johnstul@us.ibm.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: Valdis.Kletnieks@vt.edu, Lennart Poettering <mzxreary@0pointer.de>,
        Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
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
        linux-fsdevel@vger.kernel.org
In-Reply-To: <20101202011832.GO22787@shareable.org>
References: <1290532938-7332-1-git-send-email-virtuoso@slind.org>
	 <20101123224346.GA19350@tango.0pointer.de>
	 <20101201104359.GJ22787@shareable.org> <20180.1291243569@localhost>
	 <20101202011832.GO22787@shareable.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 17:55:57 -0800
Message-ID: <1291254957.2846.47.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-02 at 01:18 +0000, Jamie Lokier wrote:
> Valdis.Kletnieks@vt.edu wrote:
> > On Wed, 01 Dec 2010 10:43:59 GMT, Jamie Lokier said:
> > 
> > > So maybe CLOCK_MONOTONIC should be changed to include elapsed time
> > > during suspend/resume, and CLOCK_MONOTONIC_RAW could remain as it is,
> > > for programs that want that?
> > 
> > Wouldn't that be an API break for programs that are expecting the current
> > behavior of CLOCK_MONOTONIC?  Yes, there should be a way to request either of
> > them - but if there's only one way now, it should continue to act the current
> > way, and the added way is the second option.
> 
> I don't know.  Can you think of any program which would break if
> suspend/resume's clocks behaved like ordinary task scheduling - when a
> task doesn't run for a long time because of scheduling decisions?
> Hmm, I guess some realtime apps might like to know.

Like I mentioned earlier, CLOCK_MONOTONIC_RAW and CLOCK_MONOTONIC are
tightly tied, so anything using CLOCK_MONOTONIC_RAW would break.

It might be possible to change both, but I still think such a change
would be bad.

> Currently CLOCK_MONOTONIC jumps forwards by 4 seconds on
> suspend/resume anyway (as seen by userspace), on my x86 laptop running
> 2.6.37-rc3.  So it does already jump a bit...

So just to clarify here, by this do you mean that there's ~4 seconds
delay between the resume event and when userland apps start to run (or
possibly some of that accumulating between the app freeze and the
timekeeping suspend) ?

Or are you seeing CLOCK_MONOTONIC jump 4 seconds out of sync with
CLOCK_REALTIME? 

It should be the delta between CLOCK_MONOTONIC and CLOCK_REALTIME prior
to suspend should be that same delta + suspend time after resume. If
that's not the case, something may be broken.

thanks
-john

