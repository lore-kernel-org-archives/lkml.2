Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933753Ab1J2SBq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 14:01:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41128 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933606Ab1J2SBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 14:01:45 -0400
MIME-Version: 1.0
X-Originating-IP: [67.170.233.23]
In-Reply-To: <20111029141323.GA7036@redhat.com>
References: <1319832688-30336-1-git-send-email-scott@netsplit.com>
	<20111029141323.GA7036@redhat.com>
Date: Sat, 29 Oct 2011 11:01:44 -0700
Message-ID: <CA+bD78hSSDkOBsNTy=VjnzjYSMMtw_B6Gu2hX39G7zp2smGUVg@mail.gmail.com>
Subject: Re: [PATCH] coredump: wait on the core pattern umh at least once
From: Scott James Remnant <scott@netsplit.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Mandeep Singh Baines <msb@chromium.org>,
        Neil Horman <nhorman@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 29, 2011 at 7:13 AM, Oleg Nesterov <oleg@redhat.com> wrote:

> On 10/28, Scott James Remnant wrote:
> >
> > If a thread crashes as a result of a signal on the thread group leader
> > that signal can still be pending,
>
> No. do_coredump() clears TIF_SIGPENDING.
>
I'm definitely seeing cases where SIGTERM sent to the process group
that chrome is in results in one of chrome's thread's crashing (not
your concern, obviously), but at the point it enters this function
TIF_SIGPENDING is definitely set and the signal is SIGTERM.

The SIGTERM is in the shared pending set.

> I already tried to explain why this signal_pending() was added, but
> apparently I was not clear. I'll try again in the previous thread.
>
Could you add me to the Cc: of that thread?

Scott
