Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab0KVGYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 01:24:48 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33307 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154Ab0KVGYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 01:24:47 -0500
Date: Mon, 22 Nov 2010 11:54:40 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Ben Gamari <bgamari.foss@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>, tytso@mit.edu,
        a.p.zijlstra@chello.nl, debiandev@gmail.com, alan@lxorguk.ukuu.org.uk,
        dhaval.giani@gmail.com, efault@gmx.de, vgoyal@redhat.com,
        oleg@redhat.com, markus@trippelsdorf.de,
        mathieu.desnoyers@efficios.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101122062440.GF12043@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <C47257FC-498A-41B0-BC94-C81C72601D53@mit.edu>
 <20101119.082944.226775934.davem@davemloft.net>
 <20101119163430.GA12353@tango.0pointer.de>
 <20101119.084302.71115175.davem@davemloft.net>
 <AANLkTiksmvcLKGx7-u5CnTnZU6dgOgg7wem6qf384zUg@mail.gmail.com>
 <87mxp53z72.fsf@gmail.com>
 <20101120011330.GB4183@tango.0pointer.de>
 <20101120042557.GA12043@balbir.in.ibm.com>
 <20101120154100.GA25803@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101120154100.GA25803@tango.0pointer.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lennart Poettering <mzxreary@0pointer.de> [2010-11-20 16:41:01]:

> On Sat, 20.11.10 09:55, Balbir Singh (balbir@linux.vnet.ibm.com) wrote:
> 
> > > However, I am not sure I like the idea of having pollable files like that,
> > > because in the systemd case I am very much interested in getting
> > > recursive notifications, i.e. I want to register once for getting
> > > notifications for a full subtree instead of having to register for each
> > > cgroup individually.
> > > 
> > > My personal favourite solution would be to get a netlink msg when a
> > > cgroup runs empty. That way multiple programs could listen to the events
> > > at the same time, and we'd have an easy way to subscribe to a whole
> > > hierarchy of groups.
> > 
> > The netlink message should not be hard to do if we agree to work on
> > it. The largest objections I've heard is that netlink implies
> > network programming and most users want to be able to script in
> > their automation and network scripting is hard.
> 
> Well, the notify_on_release stuff cannot be dropped anyway at this point
> in time, so netlink support would be an addition to, not a replacement for
> the current stuff that might be useful for scripting folks.

Agreed, we still need the old notify_on_release. Are you suggesting
that for scripting we use the old interface and newer tools use
netlink?

-- 
	Three Cheers,
	Balbir
