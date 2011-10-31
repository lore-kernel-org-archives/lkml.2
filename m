Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab1JaVTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 17:19:04 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34288 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab1JaVTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 17:19:02 -0400
Date: Mon, 31 Oct 2011 17:18:51 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Scott James Remnant <scott@netsplit.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH] coredump: wait on the core pattern umh at least once
Message-ID: <20111031211851.GA5437@neilslaptop.think-freely.org>
References: <1319832688-30336-1-git-send-email-scott@netsplit.com>
 <20111029141323.GA7036@redhat.com>
 <CA+bD78hSSDkOBsNTy=VjnzjYSMMtw_B6Gu2hX39G7zp2smGUVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+bD78hSSDkOBsNTy=VjnzjYSMMtw_B6Gu2hX39G7zp2smGUVg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.6 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 29, 2011 at 11:01:44AM -0700, Scott James Remnant wrote:
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
> TIF_SIGPENDING is definitely set and the signal is SIGTERM.
> 
> The SIGTERM is in the shared pending set.
> 
> > I already tried to explain why this signal_pending() was added, but
> > apparently I was not clear. I'll try again in the previous thread.
> >
> Could you add me to the Cc: of that thread?
> 
> Scott
> 
FWIW, this is the (huge) thread, and specific post that originated the change
we're looking at:
https://lkml.org/lkml/2009/7/2/98
Neil

