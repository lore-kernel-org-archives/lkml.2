Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab0HDP7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 11:59:12 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42677 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab0HDP7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 11:59:09 -0400
Subject: Re: [PATCH] [RFC] notify userspace about time changes
From: john stultz <johnstul@us.ibm.com>
To: Alexander Shishkin <virtuoso@slind.org>, gregkh@suse.de
Cc: lkml@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Kacur <jkacur@redhat.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1280926108-24668-1-git-send-email-virtuoso@slind.org>
References: <1280926108-24668-1-git-send-email-virtuoso@slind.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 08:58:46 -0700
Message-ID: <1280937526.28884.21.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 15:48 +0300, Alexander Shishkin wrote:
> Certain userspace applications (like "clock" desktop applets or ntpd) might
> want to be notified when some other application changes the system time. It
> might also be important for an application to be able to distinguish between
> its own and somebody else's time changes.

So NTP doesn't actually care, as it will notice the STA_UNSYNC flag is
set the next time it checks adjtimex.

The clock apps example seems reasonable, but maybe isn't the most
compelling argument for adding a new kernel api.

Is there a actual use case that you need this for?  I don't really have
an issue with the code I just really want to make sure the feature would
be useful enough to justify the API and code maintenance going forward.

Doing some of my own googling, I see Apple added such a notification
method, which suggests there are apps that want this. 
http://stackoverflow.com/questions/690326/how-can-i-get-notified-of-a-system-time-change-in-my-cocoa-application

But it doesn't give any specific examples either.

thanks
-john


