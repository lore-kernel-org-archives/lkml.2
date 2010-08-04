Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611Ab0HDTTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 15:19:16 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34100 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739Ab0HDTTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 15:19:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=YDHup3+8+8CoAr19SwwVqs8F+M01q7I6tjoJq5kuE8MJvpWjZ0q1hUwiXAtml/6tB0
         zuWxXGqPHbtJqVsrJqu2DjRF6kEj+9/1fxZBioCRsjc35YE2v+8KOPSnsnmk12NYa00B
         9O905FzluK7H4Ag03nSETabodxs9SqPx2H3fc=
MIME-Version: 1.0
Date: Wed, 4 Aug 2010 22:19:14 +0300
X-Google-Sender-Auth: D-H6X_jF9eYCqJUvdSSrtNJbvLs
Message-ID: <AANLkTimHvrwQgq8dwc8oYYTjrv603DXRM_Ggy-JJ56VF@mail.gmail.com>
Subject: [GIT PULL] SLAB updates for 2.6.36-rc0
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
Cc: cl@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>, Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

There's dramatic queued up for this merge window for SLAB. Bulk of the
changes are straight-forward SLUB cleanups from Christoph Lameter's
recent SLAB/SLUB unification patch series but there's also few SLAB
and SLOB fixes thrown into the mix.

                        Pekka

The following changes since commit 9fe6206f400646a2322096b56c59891d530e8d51:
  Linus Torvalds (1):
        Linux 2.6.35

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git
for-linus

Arjan van de Ven (1):
      slab: use deferable timers for its periodic housekeeping

Bob Liu (1):
      SLOB: Free objects to their own list

Christoph Lameter (7):
      slub: Use a constant for a unspecified node.
      SLUB: Constants need UL
      slub: Check kasprintf results in kmem_cache_init()
      slub: Allow removal of slab caches during boot
      slub: Use kmem_cache flags to detect if slab is in debugging mode.
      slub numa: Fix rare allocation from unexpected node
      slub: Allow removal of slab caches during boot

Pekka Enberg (2):
      Revert "slub: Allow removal of slab caches during boot"
      Merge branches 'slab/fixes', 'slob/fixes', 'slub/cleanups' and
'slub/fixes' into for-linus

Xiaotian Feng (1):
      slab: fix caller tracking on !CONFIG_DEBUG_SLAB && CONFIG_TRACING

 include/linux/page-flags.h |    2 -
 include/linux/slab.h       |    6 ++-
 mm/slab.c                  |    2 +-
 mm/slob.c                  |    9 ++++-
 mm/slub.c                  |   86 ++++++++++++++++++++++----------------------
 5 files changed, 56 insertions(+), 49 deletions(-)
