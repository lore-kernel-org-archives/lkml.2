Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab0LAXq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 18:46:57 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37075 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377Ab0LAXq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 18:46:56 -0500
Subject: Re: [PATCH] [RFC] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for
 clock changes
From: john stultz <johnstul@us.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: Jamie Lokier <jamie@shareable.org>,
        Lennart Poettering <mzxreary@0pointer.de>,
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
In-Reply-To: <20180.1291243569@localhost>
References: <1290532938-7332-1-git-send-email-virtuoso@slind.org>
	 <20101123224346.GA19350@tango.0pointer.de>
	 <20101201104359.GJ22787@shareable.org>  <20180.1291243569@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 15:46:48 -0800
Message-ID: <1291247208.2846.10.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 17:46 -0500, Valdis.Kletnieks@vt.edu wrote:
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

We do keep track of the amount of time in suspend (total_sleep_time), so
creating a new clockid to provide CLOCK_MONOTONIC + total_sleep_time
wouldn't be hard. We just haven't had a clear articulation of why it
would be useful to expose to userland (nor a clear name to describe
exactly what it represents).

thanks
-john


