Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab0LBBTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 20:19:05 -0500
Received: from mail2.shareable.org ([80.68.89.115]:44514 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab0LBBTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 20:19:04 -0500
Date: Thu, 2 Dec 2010 01:18:33 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Valdis.Kletnieks@vt.edu
Cc: Lennart Poettering <mzxreary@0pointer.de>,
        Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org,
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
        Artem Bityutskiy <dedekind1@gmail.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] [RFC] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for clock changes
Message-ID: <20101202011832.GO22787@shareable.org>
References: <1290532938-7332-1-git-send-email-virtuoso@slind.org> <20101123224346.GA19350@tango.0pointer.de> <20101201104359.GJ22787@shareable.org> <20180.1291243569@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180.1291243569@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Wed, 01 Dec 2010 10:43:59 GMT, Jamie Lokier said:
> 
> > So maybe CLOCK_MONOTONIC should be changed to include elapsed time
> > during suspend/resume, and CLOCK_MONOTONIC_RAW could remain as it is,
> > for programs that want that?
> 
> Wouldn't that be an API break for programs that are expecting the current
> behavior of CLOCK_MONOTONIC?  Yes, there should be a way to request either of
> them - but if there's only one way now, it should continue to act the current
> way, and the added way is the second option.

I don't know.  Can you think of any program which would break if
suspend/resume's clocks behaved like ordinary task scheduling - when a
task doesn't run for a long time because of scheduling decisions?
Hmm, I guess some realtime apps might like to know.

Currently CLOCK_MONOTONIC jumps forwards by 4 seconds on
suspend/resume anyway (as seen by userspace), on my x86 laptop running
2.6.37-rc3.  So it does already jump a bit...

But see my other reply; maybe there's no need to change it.  A
reliable, immediate notification that CLOCK_MONOTONIC's relationship
to real time has been disrupted by an unknown amount would be
sufficient for the problems I have in mind.

-- Jamie

