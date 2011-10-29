Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840Ab1J2Teu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 15:34:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab1J2Tet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 15:34:49 -0400
Date: Sat, 29 Oct 2011 21:30:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Scott James Remnant <scott@netsplit.com>
Cc: linux-kernel@vger.kernel.org, Mandeep Singh Baines <msb@chromium.org>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] coredump: wait on the core pattern umh at least once
Message-ID: <20111029193027.GA22101@redhat.com>
References: <1319832688-30336-1-git-send-email-scott@netsplit.com> <20111029141323.GA7036@redhat.com> <CA+bD78hSSDkOBsNTy=VjnzjYSMMtw_B6Gu2hX39G7zp2smGUVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+bD78hSSDkOBsNTy=VjnzjYSMMtw_B6Gu2hX39G7zp2smGUVg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29, Scott James Remnant wrote:
>
> On Sat, Oct 29, 2011 at 7:13 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> > On 10/28, Scott James Remnant wrote:
> > >
> > > If a thread crashes as a result of a signal on the thread group leader
> > > that signal can still be pending,
> >
> > No. do_coredump() clears TIF_SIGPENDING.
> >
> I'm definitely seeing cases where SIGTERM sent to the process group
> that chrome is in results in one of chrome's thread's crashing (not
> your concern, obviously), but at the point it enters this function

which function? wait_for_dump_helpers?

> TIF_SIGPENDING is definitely set and the signal is SIGTERM.

Yes, this is possible. But not as result of a signal which triggers
the coredumping. And once again, this clear_thread_flag(TIF_SIGPENDING)
is simply wrong (I mean, not enough).

> > I already tried to explain why this signal_pending() was added, but
> > apparently I was not clear. I'll try again in the previous thread.
> >
> Could you add me to the Cc: of that thread?

I thought you were cc'ed ;) Sorry, I didn't realiaze that these 2
threads are totally separate. Please look at

	http://marc.info/?t=131959137800005

and at
	http://marc.info/?l=linux-kernel&m=131989970411759

in particular.

Oleg.

