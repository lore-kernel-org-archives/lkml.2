Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab0FJEWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 00:22:07 -0400
Received: from mail.lang.hm ([64.81.33.126]:51107 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109Ab0FJEWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 00:22:05 -0400
Date: Wed, 9 Jun 2010 21:21:00 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: Alan Stern <stern@rowland.harvard.edu>, tytso@mit.edu,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Brian Swetland <swetland@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@suse.de>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Felipe Balbi <felipe.balbi@nokia.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [linux-pm] suspend blockers & Android integration
In-Reply-To: <AANLkTil2JhBgJ27qcTARVj2wVgEltxZKPOc9Ddu4c8yY@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.1006092117100.17462@asgard.lang.hm>
References: <AANLkTilALyvthzh8rMiDFFP_QTz_o5hxdE8tArMUonpP@mail.gmail.com> <Pine.LNX.4.44L0.1006091031030.1728-100000@iolanthe.rowland.org> <AANLkTil2JhBgJ27qcTARVj2wVgEltxZKPOc9Ddu4c8yY@mail.gmail.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jun 2010, Arve Hj?nnev?g wrote:

>
> The power may not see the event, the process that reads the event will
> always see it. If the power manager is not in the poll call when the
> event happens, the process that reads the event can read the event
> before the power manager calls poll.
>

>
> All input events that can wake the system are handled by one
> user-space suspend blocker. Input devices come and go so we would need
> to add and remove the fds dynamically.


>
> For that to work the wakeup events would have to be reported to the
> power manager in a reliable way in the first place. Passing the file
> descriptor that the app uses to the power manager does not work for
> this, since the app could read the event while the power manager was
> not in the poll call and the power manager would never see it. Also,
> existing apps don't pass their file descriptors to the power manager,
> so it has the get the event from somewhere else.
>

why could the suspend blocker process see all events, but the power 
manager process not see the events?

have the userspace talk to the power manager the way it does to the 
suspend blocker now and what's the difference?

effectivly think s/suspend blocker/power manager/ (with the power manager 
doing all the other things that are proposed instead of grabbing the 
wakelock), the difference should be hidden to the rest of userspace.

what am I missing here?

David Lang
