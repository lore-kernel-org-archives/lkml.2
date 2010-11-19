Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab0KSTyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 14:54:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756494Ab0KSTyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 14:54:14 -0500
MIME-Version: 1.0
In-Reply-To: <87mxp53z72.fsf@gmail.com>
References: <C47257FC-498A-41B0-BC94-C81C72601D53@mit.edu> <20101119.082944.226775934.davem@davemloft.net>
 <20101119163430.GA12353@tango.0pointer.de> <20101119.084302.71115175.davem@davemloft.net>
 <AANLkTiksmvcLKGx7-u5CnTnZU6dgOgg7wem6qf384zUg@mail.gmail.com> <87mxp53z72.fsf@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 19 Nov 2010 11:48:04 -0800
Message-ID: <AANLkTi=XPxnrKKu5yuJSpJjVis7MnP5d1bvhT_gKHJyV@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: David Miller <davem@davemloft.net>, mzxreary@0pointer.de, tytso@mit.edu,
        a.p.zijlstra@chello.nl, debiandev@gmail.com, alan@lxorguk.ukuu.org.uk,
        dhaval.giani@gmail.com, efault@gmx.de, vgoyal@redhat.com,
        oleg@redhat.com, markus@trippelsdorf.de,
        mathieu.desnoyers@efficios.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 11:12 AM, Ben Gamari <bgamari.foss@gmail.com> wrote:
>
> On that note, is there a good reason why the notify_on_release interface
> works the way it does? Wouldn't it be simpler if the cgroup simply
> provided a file on which a process (e.g. systemd) could block?

Actually, the sane interface would likely just be to have a "drop on
release" interface.

Maybe some people really want to be _notified_. But my guess would
that that just dropping the cgroup when it becomes empty would be at
least a reasonable subset of users.

Who uses that thing now? The desktop launcher/systemd approach
definitely doesn't seem want the overhead of being notified and having
to remove it manually. Does anybody else really want it?

But that's really an independent question from all the other things.
But with new cgroup users, it's very possible that it turns out that
some of the original interfaces are just inconvenient and silly.

                   Linus
