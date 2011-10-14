Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab1JNQBC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:01:02 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41570 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753814Ab1JNQBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:01:00 -0400
Date: Fri, 14 Oct 2011 12:00:59 -0400 (EDT)
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
In-Reply-To: <20111014165212.7929243c@notabene.brown>
Message-ID: <Pine.LNX.4.44L0.1110141156040.2036-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, NeilBrown wrote:

> Hi Rafael,
> 
>  What do you mean by "too complicated to use in practice"?  What is you
>  measure for complexity?
>  Using suspend in a race-free way is certainly less complex than - for
>  example - configuring bluetooth.
>  And in what way is it "inadequate for other reasons"? What reasons?
> 
> 
>  The only sane way to handle suspend is for any (suitably privileged) process
>  to be able to request that suspend doesn't happen, and then for one process
>  to initiate suspend when no-one is blocking it.

One of the things Rafael didn't mention is that sometimes a kernel 
driver needs to prevent the system from suspending.  This happens when 
recharging over a USB connection.

There's no simple way for such a driver to communicate with a power
daemon.  The driver has to use something like the wakeup mechanism -- 
but currently that mechanism is optional.

Alan Stern

