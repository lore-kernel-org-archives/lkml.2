Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab1CJI1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 03:27:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752238Ab1CJI1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 03:27:22 -0500
Date: Thu, 10 Mar 2011 00:25:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Scott James Remnant <scott@netsplit.com>
Cc: Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org,
        Ken MacLeod <ken@bitsko.slc.ut.us>,
        Shaun Reich <predator106@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>, Feng Tang <feng.tang@intel.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        John Stultz <johnstul@us.ibm.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [RFCv4] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for clock
 changes
Message-Id: <20110310002534.f984f8b2.akpm@linux-foundation.org>
In-Reply-To: <AANLkTin7=rK2Sc2D7aMhPnPWU9LJq7KMSvwxv_PHERcK@mail.gmail.com>
References: <1299681411-9227-1-git-send-email-virtuoso@slind.org>
	<20110309162513.5058c824.akpm@linux-foundation.org>
	<AANLkTin7=rK2Sc2D7aMhPnPWU9LJq7KMSvwxv_PHERcK@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Mar 2011 18:01:09 -0800 Scott James Remnant <scott@netsplit.com> wrote:

> > It would be helpful to know if the identified users of this feature
> > actually find it useful and adequate. __I guess the most common
> > application is the 1,001 desktop clock widgets. __Do you have any
> > feedback from any of the owners of those?
> >
> cron is another obvious one (or init systems attempting to replace
> cron). Having to wakeup and check the time every minute can be
> non-conducive to power savings, it would be better if we could just
> sleep until the next alarm and be woken up if the time changes in
> between.
> 
> (That being said, we also need to poll for and/or check for timezone
> changes - but those are entirely userspace, so we can deal with that
> separately)

Sure, there will be lots of applications.

But what I'm asking isn't "it is a good feature".  I'm asking "is the
feature implemented well".  Ideally someone would get down and modify
cron to use the interface in this patch.

That's a bit of work (although not a huge amount) and a compromise
would be for app owners to sit down for half an hour and work through
their code and the kernel interface and let us know whether they found
the interface to be good and complete.

Because it would be most regrettable if we were to roll this feature
out and then three months later its users come back saying "what a
shame you didn't do it *this* way".

Also...  Alexander, I assume you have a userspace test app?  Please
send it and we'll add it to the changelog for testers, as example code
for implementers and as an additional way of reviewing the proposed
interface.

Thanks.
