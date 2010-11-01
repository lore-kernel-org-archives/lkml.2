Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab0KARfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 13:35:00 -0400
Received: from mx2.sophos.com ([195.166.81.53]:33294 "EHLO mx2.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab0KARe6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 13:34:58 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH 10/20] fanotify: allow userspace to override max queue depth
Date: Mon, 1 Nov 2010 17:34:55 +0000
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.5.2; x86_64; ; )
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "agruen@suse.de" <agruen@suse.de>
References: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com> <201011011709.59239.tvrtko.ursulin@sophos.com> <1288632231.3017.53.camel@localhost.localdomain>
In-Reply-To: <1288632231.3017.53.camel@localhost.localdomain>
MIME-Version: 1.0
Message-ID: <201011011734.56269.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 01/11/2010 17:34:56,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 01/11/2010 17:34:57,
	Serialize complete at 01/11/2010 17:34:57
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 Nov 2010 17:23:51 Eric Paris wrote:
> On Mon, 2010-11-01 at 17:09 +0000, Tvrtko Ursulin wrote:
> > On Thursday 28 Oct 2010 22:32:32 Eric Paris wrote:
> > > fanotify has a defualt max queue depth.  This patch allows processes
> > > which explicitly request it to have an 'unlimited' queue depth.  These
> > > processes need to be very careful to make sure they cannot fall far
> > > enough behind that they OOM the box.  Thus this flag is gated on
> > > CAP_SYS_ADMIN.
> > >
> > > Signed-off-by: Eric Paris <eparis@redhat.com>
> > > ---
> > >
> > >  fs/notify/fanotify/fanotify_user.c |    9 ++++++++-
> > >  include/linux/fanotify.h           |    5 +++--
> > >  2 files changed, 11 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/fs/notify/fanotify/fanotify_user.c
> > > b/fs/notify/fanotify/fanotify_user.c index 04f2fe4..43d66d9 100644
> > > --- a/fs/notify/fanotify/fanotify_user.c
> > > +++ b/fs/notify/fanotify/fanotify_user.c
> > > @@ -691,7 +691,14 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int,
> > > flags, unsigned int, event_f_flags) goto out_put_group;
> > >
> > >       }
> > >
> > > -     group->max_events = FANOTIFY_DEFAULT_MAX_EVENTS;
> > > +     if (flags & FAN_UNLIMITED_QUEUE) {
> > > +             fd = -EPERM;
> > > +             if (!capable(CAP_SYS_ADMIN))
> > > +                     goto out_put_group;
> >
> > Either this capable call is not needed or the one at the top of the
> > syscall needs to go if you intended to allow non-privileged access.
>
> I realize they are redundant.  But it is starting down the path of
> unpriv'd users.  I figure I already have to go back and audit everything
> we do looking for places we shouldn't allow unpriv users, so no need to
> add new ones without explicitly checking.

True, next patch mentions this higher motive, sorry for the noise.

Tvrtko

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
