Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390Ab0KSBNB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 20:13:01 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:46915 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754730Ab0KSBNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 20:13:00 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/KFIIUjPDKaKVBN27SDhy5tQQYvaKMlqXXdQL+iK
	Uhwc0KaWE8xLFy
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hans-Peter Jansen <hpj@urpla.net>, linux-kernel@vger.kernel.org,
        Lennart Poettering <mzxreary@0pointer.de>, david@lang.hm,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <20101119005942.GL6024@const.famille.thibault.fr>
References: <1289916171.5169.117.camel@maggy.simson.net>
	 <AANLkTimC_TWzKET-aabYK0TPG6fUUW06HDej6iOzYtKo@mail.gmail.com>
	 <20101116211431.GA15211@tango.0pointer.de>
	 <201011182333.48281.hpj@urpla.net>
	 <20101118231218.GX6024@const.famille.thibault.fr>
	 <1290123351.18039.49.camel@maggy.simson.net>
	 <20101118234339.GA6024@const.famille.thibault.fr>
	 <AANLkTimTNxLYGLgnS9TUT_YiMnmDVrqseByGGogj+A4Z@mail.gmail.com>
	 <20101119000204.GE6024@const.famille.thibault.fr>
	 <AANLkTi=n4r9STKsx76t--HbK7EiUWaaPm7tUN2nXtqxA@mail.gmail.com>
	 <20101119005942.GL6024@const.famille.thibault.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 18:12:37 -0700
Message-ID: <1290129157.18039.70.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 01:59 +0100, Samuel Thibault wrote:
> Linus Torvalds, le Thu 18 Nov 2010 16:42:27 -0800, a écrit :
> > Once per session is about as much as is acceptable. That's the kind of
> > granularity we should look at. So things like "groups per user",
> > "groups per session", "groups per one graphical application" are good.
> > Not things that can happen tens of thousands of times a second.
> 
> All right.  I believe that should already work quite well both for
> desktop and servers indeed.  "Per one graphical application" will most
> probably require desktop panel patching, however.

I think that could be done with a fork flag with the same semantics as
reset on fork.  Once your task launcher (ala kdeinit) is tagged, it
launches task groups, the children lose that ability.  That requires
userspace interaction though, dunno how you'd detect automatically.

	-Mike

