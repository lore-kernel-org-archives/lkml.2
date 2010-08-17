Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab0HQJpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 05:45:30 -0400
Received: from mx5.sophos.com ([213.31.172.35]:37733 "EHLO mx5.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab0HQJp3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 05:45:29 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Eric Paris <eparis@redhat.com>
Subject: Re: [GIT PULL] notification tree - try 37!
Date: Tue, 17 Aug 2010 10:45:25 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
CC: Andreas Gruenbacher <agruen@suse.de>,
        Christoph Hellwig <hch@infradead.org>,
        Matt Helsley <matthltc@us.ibm.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Michael Kerrisk <michael.kerrisk@gmail.com>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com> <201008162232.36873.agruen@suse.de> <1282016387.21419.113.camel@acb20005.ipt.aol.com>
In-Reply-To: <1282016387.21419.113.camel@acb20005.ipt.aol.com>
MIME-Version: 1.0
Message-ID: <201008171045.26155.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 17/08/2010 10:45:26,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 17/08/2010 10:45:26,
	Serialize complete at 17/08/2010 10:45:26
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 Aug 2010 04:39:47 Eric Paris wrote:
> > Q: What prevents the system from going out of memory when a listener
> > decides to stop reading events or simply can't keep up?  There doesn't
> > seem to be a limit on the queue depth.  Listeners currently need
> > CAP_SYS_ADMIN, but somehow limiting the queue depth and throttling when
> > things start to go bad still sounds like a reasonable thing to do,
> > right?)
>
> It's an interesting question and obviously one that I've thought about.
> You remember when we talked previously I said the hardest part left was
> allowing non-root users to use the interface.  It gets especially
> difficult when thinking about perm-events.  I was specifically told not
> to timeout or drop those.  But when dealing with non-root users using
> perm events?   As for pure notification we can do something like inotify
> does quite easily.

Why no timeouts? It sounds like a feasible way to work around listeners which
have stopped working. (Timeout and -ETIME for example to be clear, not
allowing access).

Alternative might be to expose queue size per group (and some additional group
info) so a daemon could keep an eye on listeners which are not making progress
and act accordingly. Sometimes appropriate action would be to restart, or to
kill, or even spawn a new one. Last bit is especially useful with some FUSE
filesystems to avoid deadlocks. Otherwise listener can get a perm event for
the top level, and then another perm event is generated when FUSE opens the
underlying object and there is noone to handle it.

But this can also work together with timeouts.

Tvrtko

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
