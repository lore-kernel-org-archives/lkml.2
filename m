Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab0DDNrq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 09:47:46 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:54286 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754251Ab0DDNrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 09:47:41 -0400
Date: Sun, 4 Apr 2010 15:47:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, Christoph Hellwig <hch@infradead.org>,
       Mark Lord <lkml@rtr.ca>, Michael Tokarev <mjt@tls.msk.ru>,
       david@lang.hm, NeilBrown <neilb@suse.de>, Rob Landley <rob@landley.net>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: fsck more often when powerfail is detected (was Re: wishful
	thinking about atomic, multi-sector or full MD stripe width, writes
	in storage)
Message-ID: <20100404134729.GA1388@ucw.cz>
References: <20090831132139.GA5425@infradead.org> <4A9F230F.40707@redhat.com> <m3ab1cp9ii.fsf@intrepid.localdomain> <4A9FA5F2.9090704@redhat.com> <m3ljkwnoct.fsf@intrepid.localdomain> <4A9FC9B3.1080809@redhat.com> <m3ab1cnn7y.fsf@intrepid.localdomain> <4A9FCF6B.1080704@redhat.com> <20090907114534.GP23450@elf.ucw.cz> <20090907131026.GC32427@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907131026.GC32427@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Yes, but ext3 was designed to handle the partial write  (according to
> > tytso).
> 
> I'm not sure what made you think that I said that.  In practice things
> usually work out, as a conseuqence of the fact that ext3 uses physical
> block journaling, but it's not perfect, becase...

Ok; so the journalling actually  is not reliable on many machines --
not even disk drive manufacturers guarantee full block writes AFAICT.

Maybe there's time to reviwe the patch to increase mount count by >1
when journal is replayed, to do fsck more often when powerfails are
present?


> > > Also, when you enable the write cache (MD or not) you are buffering 
> > > multiple MB's of data that can go away on power loss. Far greater (10x) 
> > > the exposure that the partial RAID rewrite case worries about.
> > 
> > Yes, that's what barriers are for. Except that they are not there on
> > MD0/MD5/MD6. They actually work on local sata drives...
> 
> Yes, but ext3 does not enable barriers by default (the patch has been
> submitted but akpm has balked because he doesn't like the performance
> degredation and doesn't believe that Chris Mason's "workload of doom"
> is a common case).  Note though that it is possible for dirty blocks
> to remain in the track buffer for *minutes* without being written to
> spinning rust platters without a barrier.

So we do wrong thing by default. Another reason to do fsck more often
when powerfails are present?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
