Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab0DDRkv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 13:40:51 -0400
Received: from THUNK.ORG ([69.25.196.29]:40469 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab0DDRkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 13:40:43 -0400
Date: Sun, 4 Apr 2010 13:39:12 -0400
From: tytso@mit.edu
To: Pavel Machek <pavel@ucw.cz>
Cc: Ric Wheeler <rwheeler@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Christoph Hellwig <hch@infradead.org>, Mark Lord <lkml@rtr.ca>,
       Michael Tokarev <mjt@tls.msk.ru>, david@lang.hm,
       NeilBrown <neilb@suse.de>, Rob Landley <rob@landley.net>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: fsck more often when powerfail is detected (was Re: wishful
 thinking about atomic, multi-sector or full MD stripe width, writes in
 storage)
Message-ID: <20100404173912.GF18524@thunk.org>
Mail-Followup-To: tytso@mit.edu, Pavel Machek <pavel@ucw.cz>,
	Ric Wheeler <rwheeler@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Hellwig <hch@infradead.org>, Mark Lord <lkml@rtr.ca>,
	Michael Tokarev <mjt@tls.msk.ru>, david@lang.hm,
	NeilBrown <neilb@suse.de>, Rob Landley <rob@landley.net>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
References: <4A9F230F.40707@redhat.com>
 <m3ab1cp9ii.fsf@intrepid.localdomain>
 <4A9FA5F2.9090704@redhat.com>
 <m3ljkwnoct.fsf@intrepid.localdomain>
 <4A9FC9B3.1080809@redhat.com>
 <m3ab1cnn7y.fsf@intrepid.localdomain>
 <4A9FCF6B.1080704@redhat.com>
 <20090907114534.GP23450@elf.ucw.cz>
 <20090907131026.GC32427@mit.edu>
 <20100404134729.GA1388@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100404134729.GA1388@ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 04, 2010 at 03:47:29PM +0200, Pavel Machek wrote:
> > Yes, but ext3 does not enable barriers by default (the patch has been
> > submitted but akpm has balked because he doesn't like the performance
> > degredation and doesn't believe that Chris Mason's "workload of doom"
> > is a common case).  Note though that it is possible for dirty blocks
> > to remain in the track buffer for *minutes* without being written to
> > spinning rust platters without a barrier.
> 
> So we do wrong thing by default. Another reason to do fsck more often
> when powerfails are present?

Or migrate to ext4, which does use barriers by defaults, as well as
journal-level checksumming.  :-)

As far as changing the default to enable barriers for ext3, you'll
need to talk to akpm about that; he's the one who has been against it
in the past.

					- Ted
