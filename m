Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab0KSDPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 22:15:16 -0500
Received: from mail.openrapids.net ([64.15.138.104]:40484 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751527Ab0KSDPO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 22:15:14 -0500
Date: Thu, 18 Nov 2010 22:15:11 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Dhaval Giani <dhaval.giani@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101119031511.GA24861@Krystal>
References: <1289856350.14719.135.camel@maggy.simson.net> <20101116015648.GA11534@redhat.com> <1289916171.5169.117.camel@maggy.simson.net> <1289916683.2109.625.camel@laptop> <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com> <20101116170312.GA19327@tango.0pointer.de> <1289930934.2109.644.camel@laptop> <20101116200546.GB27235@tango.0pointer.de> <4CE5C66F.3050300@zytor.com> <20101119004210.GK6024@const.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20101119004210.GK6024@const.famille.thibault.fr>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 22:12:14 up 57 days,  7:14,  3 users,  load average: 0.11, 0.15,
	0.14
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Samuel Thibault (samuel.thibault@ens-lyon.org) wrote:
> H. Peter Anvin, le Thu 18 Nov 2010 16:35:59 -0800, a écrit :
> > On 11/16/2010 12:05 PM, Lennart Poettering wrote:
> > > On Tue, 16.11.10 19:08, Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> > > 
> > >>
> > >> On Tue, 2010-11-16 at 18:03 +0100, Lennart Poettering wrote:
> > >>> Binding something like this to TTYs is just backwards. No graphical
> > >>> session has a TTY attached anymore. And there might be multiple TTYs
> > >>> used in the same session. 
> > >>
> > >> Using a group per tty makes sense for us console jockeys..
> > > 
> > > Well, then maybe you shouldn't claim this was relevant for anybody but
> > > yourself. Because it is irrelevant for most users if it is bound to the TTY.
> > > 
> > 
> > For what it's worth, I suspect that the object that should be bound to
> > is probably not the tty, but rather the session ID of the process (which
> > generally is 1:1 with controlling TTY for console processes.)
> 
> Agreed.
> 
> That'll catch both the tty case (implemented by the proposed patch), and
> the rest.

This really does make a lot of sense. Tying on the Session ID rather than the
TTY would allow to deal with graphical applications by letting them specify
session IDs with setsid() when the application starts. It seems much more
generic than TTY, and maps to TTY already.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
