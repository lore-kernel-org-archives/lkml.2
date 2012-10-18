Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab2JRWfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 18:35:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223Ab2JRWfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 18:35:08 -0400
Date: Thu, 18 Oct 2012 19:35:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Fw: [GIT PULL for v3.7-rc1] media fixes
Message-ID: <20121018193503.53565401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For:
	- one Kconfig fix patch;
	- one patch fixing DocBook breakage due to the drivers/media UAPI changes;
	- the remaining UAPI media changes (DVB API).

I'm aware that is is a little late for the UAPI renames for the DVB API, but IMHO,
it is better to merge it for 3.7, due to two reasons:

	1) There is a major rename at 3.7 (not only uapi changes, but also the
	   entire media drivers were reorganized on 3.7, in order to simplify
	   the Kconfig logic, and easy drivers selection, especially for hybrid
	   devices). By confining all those renames there at 3.7 it will cause
	   all the harm at for media developers on just one shot. Stable backports
	   upstream and at distros will likely welcome it as well, as they
	   won't need to check what changed on 3.7 and what was postponed for on 3.8.

	2) The V4L2 DocBook Makefile creates a cross-reference between the media
	   API headers and the specs. This helps us _a_lot_ to be sure that all
	   API improvements are properly documented. Every time a header changes from
	   one place to another, DocBook/media/Makefile needs to be patched.
	   Currently, the DocBook breakage patch depends on the DVB UAPI.

Of course, if you prefer to not merge this as-is, it is not a big deal to break the
DocBook fixup into two parts, one for 3.7 and another one for 3.8. Just let me know
and I'll revert those two patches and make another pull request one without the DVB
UAPI patch.

Thank you!
Mauro

-

Latest commit at the branch: 
2c76a12ae9f5e6e2afc400bfbdd8b326e7d36b2a [media] Kconfig: Fix dependencies for driver autoselect options
The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to 2c76a12ae9f5e6e2afc400bfbdd8b326e7d36b2a:

  [media] Kconfig: Fix dependencies for driver autoselect options (2012-10-17 16:45:56 -0300)

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate include/linux/dvb

Mauro Carvalho Chehab (3):
      Merge tag 'v3.7-rc1' into staging/for_v3.8
      DocBook/media/Makefile: Fix build due to uapi breakage
      [media] Kconfig: Fix dependencies for driver autoselect options

 Documentation/DocBook/media/Makefile    |  76 ++++-----
 drivers/media/Kconfig                   |  18 ++-
 include/linux/dvb/Kbuild                |   8 -
 include/linux/dvb/dmx.h                 | 130 +--------------
 include/linux/dvb/video.h               | 249 +----------------------------
 include/uapi/linux/dvb/Kbuild           |   8 +
 include/{ => uapi}/linux/dvb/audio.h    |   0
 include/{ => uapi}/linux/dvb/ca.h       |   0
 include/uapi/linux/dvb/dmx.h            | 155 ++++++++++++++++++
 include/{ => uapi}/linux/dvb/frontend.h |   0
 include/{ => uapi}/linux/dvb/net.h      |   0
 include/{ => uapi}/linux/dvb/osd.h      |   0
 include/{ => uapi}/linux/dvb/version.h  |   0
 include/uapi/linux/dvb/video.h          | 274 ++++++++++++++++++++++++++++++++
 14 files changed, 487 insertions(+), 431 deletions(-)
 rename include/{ => uapi}/linux/dvb/audio.h (100%)
 rename include/{ => uapi}/linux/dvb/ca.h (100%)
 create mode 100644 include/uapi/linux/dvb/dmx.h
 rename include/{ => uapi}/linux/dvb/frontend.h (100%)
 rename include/{ => uapi}/linux/dvb/net.h (100%)
 rename include/{ => uapi}/linux/dvb/osd.h (100%)
 rename include/{ => uapi}/linux/dvb/version.h (100%)
 create mode 100644 include/uapi/linux/dvb/video.h

