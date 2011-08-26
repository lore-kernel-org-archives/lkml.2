Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab1HZONv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 10:13:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130Ab1HZONu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 10:13:50 -0400
Date: Fri, 26 Aug 2011 16:10:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, Jovi Zhang <bookjovi@gmail.com>,
        dhowells@redhat.com, roland@redhat.com, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coredump: fix pipe coredump when core limit is 0
Message-ID: <20110826141032.GA13620@redhat.com>
References: <48dnn9u5x3e4qoh8meht42xk.1313966177259@email.android.com> <4E527684.3020206@draigBrady.com> <20110822161914.GA9399@redhat.com> <CACV3sbJjDhzKq8YQEnrTQPVVw7YsZjLe45G5sWaMRBk3+Vxkcg@mail.gmail.com> <20110824110134.GA17362@hmsreliant.think-freely.org> <20110825155735.GA5380@redhat.com> <4E5762C7.50909@draigBrady.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E5762C7.50909@draigBrady.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26, Pádraig Brady wrote:
>
> On 08/25/2011 04:57 PM, Oleg Nesterov wrote:
> > On 08/24, Neil Horman wrote:
> >>
> >> The long and the short of it is, making RLIMIT_CORE == 0 for the ispipe case
> >> skip the core dump, breaks lots of user space expectations
> >
> > Not sure this really makes sense, but perhaps ispipe can skip the dump
> > if RLIMIT_CORE == 0 _and_ the signal was sent from the user-space.
>
> I like the sound of that, though don't know the details for
> determining signal origin. SIGQUIT generated from a Ctrl-\
> from the tty driver might be problematic for example.

Hmm. Thanks for correcting me.

Indeed, contrary to what I expected tty uses SEND_SIG_PRIV, not
SEND_SIG_NOINFO. This is SI_KERNEL. Hmm. OTOH, this makes sense
from check_kill_permission() pov.

Thanks.

Oleg.

