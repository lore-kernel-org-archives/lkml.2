Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab2JKMhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 08:37:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:32980 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab2JKMhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 08:37:12 -0400
Date: Thu, 11 Oct 2012 09:37:03 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Oliver Endriss <o.endriss@gmx.de>
Cc: David Howells <dhowells@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PULL] Disintegrate UAPI for media
Message-ID: <20121011093703.24b60232@infradead.org>
In-Reply-To: <201210111023.51311.o.endriss@gmx.de>
References: <30699.1349789424@warthog.procyon.org.uk>
	<20121009183908.1e402a43@infradead.org>
	<201210111023.51311.o.endriss@gmx.de>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 11 Oct 2012 10:23:50 +0200
Oliver Endriss <o.endriss@gmx.de> escreveu:

> Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> > Em Tue, 09 Oct 2012 14:30:24 +0100
> > David Howells <dhowells@redhat.com> escreveu:
> > 
> > > Can you merge the following branch into the media tree please.
> > > 
> > > This is to complete part of the Userspace API (UAPI) disintegration for which
> > > the preparatory patches were pulled recently.  After these patches, userspace
> > > headers will be segregated into:
> > > 
> > > 	include/uapi/linux/.../foo.h
> > > 
> > > for the userspace interface stuff, and:
> > > 
> > > 	include/linux/.../foo.h
> > > 
> > > for the strictly kernel internal stuff.
> > > 
> > > ---
> > > The following changes since commit 9e2d8656f5e8aa214e66b462680cf86b210b74a8:
> > > 
> > >   Merge branch 'akpm' (Andrew's patch-bomb) (2012-10-09 16:23:15 +0900)
> > > 
> > > are available in the git repository at:
> > > 
> > > 
> > >   git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-media-20121009
> > > 
> > > for you to fetch changes up to 1c436decd49665be131887b08d172a7989cdceee:
> > > 
> > >   UAPI: (Scripted) Disintegrate include/linux/dvb (2012-10-09 09:48:42 +0100)
> > > 
> > > ----------------------------------------------------------------
> > > UAPI Disintegration 2012-10-09
> > > 
> > > ----------------------------------------------------------------
> > > David Howells (1):
> > >       UAPI: (Scripted) Disintegrate include/linux/dvb
> > > 
> > >  include/linux/dvb/Kbuild                |   8 -
> > >  include/linux/dvb/dmx.h                 | 130 +--------------
> > >  include/linux/dvb/video.h               | 249 +----------------------------
> > >  include/uapi/linux/dvb/Kbuild           |   8 +
> > >  include/{ => uapi}/linux/dvb/audio.h    |   0
> > >  include/{ => uapi}/linux/dvb/ca.h       |   0
> > >  include/uapi/linux/dvb/dmx.h            | 155 ++++++++++++++++++
> > >  include/{ => uapi}/linux/dvb/frontend.h |   0
> > >  include/{ => uapi}/linux/dvb/net.h      |   0
> > >  include/{ => uapi}/linux/dvb/osd.h      |   0
> > >  include/{ => uapi}/linux/dvb/version.h  |   0
> > >  include/uapi/linux/dvb/video.h          | 274 ++++++++++++++++++++++++++++++++
> > >  12 files changed, 439 insertions(+), 385 deletions(-)
> > >  rename include/{ => uapi}/linux/dvb/audio.h (100%)
> > >  rename include/{ => uapi}/linux/dvb/ca.h (100%)
> > >  create mode 100644 include/uapi/linux/dvb/dmx.h
> > >  rename include/{ => uapi}/linux/dvb/frontend.h (100%)
> > >  rename include/{ => uapi}/linux/dvb/net.h (100%)
> > >  rename include/{ => uapi}/linux/dvb/osd.h (100%)
> > >  rename include/{ => uapi}/linux/dvb/version.h (100%)
> > >  create mode 100644 include/uapi/linux/dvb/video.h
> > 
> > Hmm... last year, it was decided that we would be putting the DVB av7110-only
> > API files on a separate place, as the API there conflicts with V4L/alsa APIs
> 
> Wrong! Hans Verkuil and you tried to do it, without caring that it would
> break userspace, and it was NAKed.

My understanding here is that, as the file location will change
with this series, your original concern is now void, as userspace
will require patches to use the new location. So, if we're willing
to do it, let's put this one-driver-only obsolete API on a separate
place.


Cheers,
Mauro
