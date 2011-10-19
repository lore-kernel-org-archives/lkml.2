Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab1JSQTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 12:19:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33884 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753200Ab1JSQTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 12:19:22 -0400
Date: Wed, 19 Oct 2011 12:19:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: NeilBrown <neilb@suse.de>
cc: John Stultz <john.stultz@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of suspend/hibernate
 interfaces
In-Reply-To: <20111019095540.1011993d@notabene.brown>
Message-ID: <Pine.LNX.4.44L0.1110191208570.2067-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Oct 2011, NeilBrown wrote:

> > There's another way to implement "inhibit suspend" -- via the notify 
> > mechanism.  If the client doesn't respond to a callback, the server 
> > won't suspend.  Hence if people use the fd-timer approach, 
> > be-awake-after isn't needed.
> 
> I don't like that approach though.  It leaves the daemon thinking "we are on
> the way towards suspend" and that is what it tells other clients.  But really
> we are in state "someone doesn't want us to suspend now".
> So some clients are assuming suspend is imminent and are waiting expectantly
> for it to be over, but in reality the system is staying awake and only one
> client knows about it.

Clients should not make assumptions of that sort.  They have no need to
know exactly what the daemon is doing, and there's no reason for the
daemon to tell them.

All a client needs to know is whether or not _it_ is busy, so that it
can provide correct information to the daemon.  (Some clients may also
need to be notified each time the system resumes -- that's a separate
matter.)  As for the rest, a client may as well assume that the system
is perpetually on the verge of suspending, except when it has
personally told the daemon to stay awake.

On the daemon's side, I don't think there is a significant difference
between "we are on the way toward suspend and waiting for this client's
response" and "this client doesn't want us to suspend now".  Either
way, the daemon can't make any forward progress until it hears from
the client -- and the client might send an update at any time.

Alan Stern

