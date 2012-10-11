Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab2JKI0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 04:26:31 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:50205 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751656Ab2JKI01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 04:26:27 -0400
X-Authenticated: #476490
X-Provags-ID: V01U2FsdGVkX181Y9RCBIs14zl2XcQfXCIMdnSqsY8UaqQNrN8YuF
	RmWzysgZHjmM/A
From: Oliver Endriss <o.endriss@gmx.de>
Organization: Escape GmbH
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Re: [GIT PULL] Disintegrate UAPI for media
Date: Thu, 11 Oct 2012 10:23:50 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-486; KDE/4.8.4; i686; ; )
Cc: David Howells <dhowells@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
References: <30699.1349789424@warthog.procyon.org.uk> <20121009183908.1e402a43@infradead.org>
In-Reply-To: <20121009183908.1e402a43@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210111023.51311.o.endriss@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> Em Tue, 09 Oct 2012 14:30:24 +0100
> David Howells <dhowells@redhat.com> escreveu:
> 
> > Can you merge the following branch into the media tree please.
> > 
> > This is to complete part of the Userspace API (UAPI) disintegration for which
> > the preparatory patches were pulled recently.  After these patches, userspace
> > headers will be segregated into:
> > 
> > 	include/uapi/linux/.../foo.h
> > 
> > for the userspace interface stuff, and:
> > 
> > 	include/linux/.../foo.h
> > 
> > for the strictly kernel internal stuff.
> > 
> > ---
> > The following changes since commit 9e2d8656f5e8aa214e66b462680cf86b210b74a8:
> > 
> >   Merge branch 'akpm' (Andrew's patch-bomb) (2012-10-09 16:23:15 +0900)
> > 
> > are available in the git repository at:
> > 
> > 
> >   git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-media-20121009
> > 
> > for you to fetch changes up to 1c436decd49665be131887b08d172a7989cdceee:
> > 
> >   UAPI: (Scripted) Disintegrate include/linux/dvb (2012-10-09 09:48:42 +0100)
> > 
> > ----------------------------------------------------------------
> > UAPI Disintegration 2012-10-09
> > 
> > ----------------------------------------------------------------
> > David Howells (1):
> >       UAPI: (Scripted) Disintegrate include/linux/dvb
> > 
> >  include/linux/dvb/Kbuild                |   8 -
> >  include/linux/dvb/dmx.h                 | 130 +--------------
> >  include/linux/dvb/video.h               | 249 +----------------------------
> >  include/uapi/linux/dvb/Kbuild           |   8 +
> >  include/{ => uapi}/linux/dvb/audio.h    |   0
> >  include/{ => uapi}/linux/dvb/ca.h       |   0
> >  include/uapi/linux/dvb/dmx.h            | 155 ++++++++++++++++++
> >  include/{ => uapi}/linux/dvb/frontend.h |   0
> >  include/{ => uapi}/linux/dvb/net.h      |   0
> >  include/{ => uapi}/linux/dvb/osd.h      |   0
> >  include/{ => uapi}/linux/dvb/version.h  |   0
> >  include/uapi/linux/dvb/video.h          | 274 ++++++++++++++++++++++++++++++++
> >  12 files changed, 439 insertions(+), 385 deletions(-)
> >  rename include/{ => uapi}/linux/dvb/audio.h (100%)
> >  rename include/{ => uapi}/linux/dvb/ca.h (100%)
> >  create mode 100644 include/uapi/linux/dvb/dmx.h
> >  rename include/{ => uapi}/linux/dvb/frontend.h (100%)
> >  rename include/{ => uapi}/linux/dvb/net.h (100%)
> >  rename include/{ => uapi}/linux/dvb/osd.h (100%)
> >  rename include/{ => uapi}/linux/dvb/version.h (100%)
> >  create mode 100644 include/uapi/linux/dvb/video.h
> 
> Hmm... last year, it was decided that we would be putting the DVB av7110-only
> API files on a separate place, as the API there conflicts with V4L/alsa APIs

Wrong! Hans Verkuil and you tried to do it, without caring that it would
break userspace, and it was NAKed.

Btw, if there is an API conflict, you guys created it.

Anyone, who is interested in the _true_ history, should have a look at
the GIT changelog:
- dvb/{video.h,audio.h,osd.h} was the original decoder API.
- Then Hans extended this API, still using the same files.
- Later the v4l guys decided to create a new API.
- Now they want to (re)move the old one, breaking userspace.

I explicitly NAK any attempt to break userspace applications and tools!
There is no reason to do it!

> and are used only by one upstream driver (there were two drivers using them,
> at that time). As you might notice, av7110 hardware is really old, not 
> manufactured anymore since maybe 10 years ago, and it is an unmaintained
> driver.

The driver works fine, and it will continue to do so, unless someone
tampers with it. It does not require maintenance.
The hardware is old, but it is still in use, as it is easy to create a
pc-based settopbox with it.

> Some developers complained, arguing that moving it to a separate file would
> be breaking the compilation on existing tools (they're basically concerned with
> it due to out-of-tree drivers - mostly propietary ones, that use this API).

It you move the API somewhere else, you will break userspace applications
like VDR. This is not acceptable.

> Now that we're moving everything, it does make sense to do that, moving 
> dvb/(audio|osd|video).h to someplace else (maybe linux/dvb/av7110.h or
> linux/dvb/legacy/*.h).

As far as I understand the original patchset, it will not break
userspace, as it will simply move all files somewhere else, preserving
file names and the position of the files in the tree.

Mauro is trying to the move the old decoder API somewhere else, possibly
into a different file, which will definitely break userspace.
NAK for this!

Regards,
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
