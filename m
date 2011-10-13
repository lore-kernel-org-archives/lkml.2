Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab1JMPQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:16:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59270 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753355Ab1JMPQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:16:24 -0400
Date: Thu, 13 Oct 2011 11:16:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: NeilBrown <neilb@suse.de>
cc: markgross@thegnar.org, <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, <arve@android.com>,
        <amit.kucheria@linaro.org>, <farrowg@sg.ibm.com>,
        "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        <linux-pm@lists.linux-foundation.org>, <khilman@ti.com>,
        Magnus Damm <damm@opensource.se>, <mjg@redhat.com>,
        <peterz@infradead.org>
Subject: Re: [markgross@thengar.org: [RFC] wake up notifications and suspend
 blocking (aka more wakelock stuff)]
In-Reply-To: <20111013163526.3863be01@notabene.brown>
Message-ID: <Pine.LNX.4.44L0.1110131111200.2026-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Oct 2011, NeilBrown wrote:

> Nope, but I'm keen for you to convince me.  Identify a wakeup event that
> cannot be made visible to poll (or to user-space by some other
> mechanism) before the wakeup_source needs to be deactivated.  Or if I've
> misunderstood what sort of notification is problematic, help me understand.

Here's an example (just for kicks, not completely relevant to your
discussion): A USB keyboard key release.  Unlike key presses, key
releases need not generate input events.  If no processes are
monitoring the raw keyboard event queue then the release is not visible
to userspace at all, hence not visible before the wakeup_source needs
to be deactivated.

Alan Stern

