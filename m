Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab0HXItG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 04:49:06 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:36458 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab0HXItE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 04:49:04 -0400
Date: Tue, 24 Aug 2010 09:49:02 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: [REGRESSION, i915]: Periodic stalls with 2.6.36-rc2
Message-ID: <20100824084902.GA27569@sucs.org>
References: <20100823233551.GA31920@sucs.org> <89kc63$hrmse5@fmsmga002.fm.intel.com> <20100824075741.GA11000@sucs.org> <8u3s8d$jcg467@orsmga001.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8u3s8d$jcg467@orsmga001.jf.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 09:16:50AM +0100, Chris Wilson wrote:
> 
> Ok, I'm a little happier that the hangcheck could be just another symptom
> of the problem...
> 
> I think it is safe to assume that the bug is in i915, so restricting the
> bisect to just drm seems plausible:
> 
> git bisect start drivers/gpu/drm
> git bisect good 2.6.36-rc1
> git bisect bad 2.6.36-rc2

I should mention that I ran a similar bisect yesterday but it led to a dead
end:

# bad: [9ee47476d6734c9deb9ae9ab05d963302f6b6150] Merge branch 'radix-tree' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev
# good: [da5cabf80e2433131bf0ed8993abc0f7ea618c73] Linux 2.6.36-rc1
git bisect start 'HEAD' 'v2.6.36-rc1'
# good: [d1126ad907ce197ff45fbc2369fbeaf8ae6f75a8] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid
git bisect good d1126ad907ce197ff45fbc2369fbeaf8ae6f75a8
# bad: [4fefe435626758b14e6c05d2a5f8d71a997c0ad6] drm/i915,intel_agp: Add support for Sandybridge D0
git bisect bad 4fefe435626758b14e6c05d2a5f8d71a997c0ad6
# bad: [2e88e40bed136a7b7cb1c77d8dc6bd181d0d2732] drm/i915/sdvo: Markup a few constant strings.
git bisect bad 2e88e40bed136a7b7cb1c77d8dc6bd181d0d2732
# bad: [6146b3d61925116e3fecce36c2fd873665bd6614] drm/i915: i8xx also doesn't like multiple oustanding pageflips
git bisect bad 6146b3d61925116e3fecce36c2fd873665bd6614
# bad: [e044218a8ecb560b6fad65912a4e7e509db40414] drm/i915/sdvo: Add dot crawl property
git bisect bad e044218a8ecb560b6fad65912a4e7e509db40414
# bad: [45d7f32c7a43cbb9592886d38190e379e2eb2226] Merge git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile
git bisect bad 45d7f32c7a43cbb9592886d38190e379e2eb2226

All the bad kernels above boot EXTREMELY slowly and it's not clear why. Using
the results above to run your tests produced the following:

Bisecting: a merge base must be tested
[45d7f32c7a43cbb9592886d38190e379e2eb2226] Merge git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile
git bisect bad 45d7f32c7a43cbb9592886d38190e379e2eb2226
The merge base 45d7f32c7a43cbb9592886d38190e379e2eb2226 is bad.
This means the bug has been fixed between 45d7f32c7a43cbb9592886d38190e379e2eb2226 and [da5cabf80e2433131bf0ed8993abc0f7ea618c73].

As mentioned in the first mail, c584c5107bfd97e2aa41c798e3b213bcdd4eae7
seems to be good but 45d7f32c7a43cbb9592886d38190e379e2eb2226 does
not...

Any ideas?

> And yes, it does apppear that the false detection rate for TV has changed.
> The suspicion is that the change to intel_wait_for_vblank() is actually
> causing issues here.

OK.

-- 
Sitsofe | http://sucs.org/~sits/
