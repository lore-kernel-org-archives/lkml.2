Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab1JQPnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 11:43:18 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47995 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752537Ab1JQPnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 11:43:17 -0400
Date: Mon, 17 Oct 2011 11:43:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: NeilBrown <neilb@suse.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of suspend/hibernate
 interfaces
In-Reply-To: <20111017104827.52a90114@notabene.brown>
Message-ID: <Pine.LNX.4.44L0.1110171135360.2430-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011, NeilBrown wrote:

> .... Actually, the more I think about it, the more sense it makes to include
> the wake-up-at-time service with the suspend-daemon.  Then the RTC alarm
> doesn't need a wakeup_source.
> So my hypothetical suspend-daemon provides 2 services:
>  1/ Client can say "Don't suspend after X".  If X is in the past it means
>     don't suspend at all. In the future it means "If you suspend before
>     this, be sure to wake up by X".  This request must be explicitly
>     cancelled (though some mechanism is needed so that if the process dies
>     it is automatically cancelled).
>  2/ Client can say "check with me before entering suspend".  Client needs to
>     respond to any callback promptly, but can register a "don't suspend after
>     now" request first.
>     (Client probably gets a callback both on suspend and resume)

1/ can be a separate type of communication channel to the daemon.  The
client opens a connection and sends the time X.  It then blocks waiting
for a response.  The daemon waits until X (using RTC wakeup alarms as
necessary), then acknowledges the request and prevents further suspends
until the connection is closed.

2/ is the normal client communication mechanism that I described 
earlier.  I don't see why a callback would be needed during resume in 
general, although some clients might want to be informed.

Alan Stern

