Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab0FVQqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 12:46:15 -0400
Received: from smtp.nokia.com ([192.100.122.233]:64103 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab0FVQqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 12:46:14 -0400
Date: Tue, 22 Jun 2010 19:50:11 +0300
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: ext Rusty Russell <rusty@rustcorp.com.au>
Cc: "dedekind1@gmail.com" <dedekind1@gmail.com>, Takashi Iwai <tiwai@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sitsofe Wheeler <sitsofe@yahoo.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [PULL] param sysfs oops (simple, leaky) fix, bool arrays fix
Message-ID: <20100622165011.GZ17639@pcarmody-desktop>
References: <200910290902.13724.rusty@rustcorp.com.au> <s5hmxwevlm4.wl%tiwai@suse.de> <1273049369.3702.127.camel@localhost> <201005061158.13098.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005061158.13098.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 22 Jun 2010 16:45:14.0448 (UTC) FILETIME=[49B16500:01CB122A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/10 04:28 +0200, ext Rusty Russell wrote:
> On Wed, 5 May 2010 06:19:29 pm Artem Bityutskiy wrote:
> > > Fixing in the way of the later upstream is a bit too intrusive as a
> > > stable patch.  So, I'm also not sure whether we should take it,
> > > too...
> > 
> > To be frank I do not really understand what you mean.
> > 
> > Anyway, I just humbly suggest not to have the "no one uses that, let's
> > have a leak" attitude. I do understand that this is a 'it's a lot of
> > churn for not much gain'. However, I think the rmmod leak is large
> > enough issue.
> 
> Thanks Artem, that's exactly the kind of feedback we need.
> 
> For most people, module parameters are rare, and module removal is rare.
> So the amount of leak is less than the size of the code we would add to fix
> it.
> 
> If this is hitting you, it clearly changes the priorities.  I will include
> the patches now.

Rusty,

Artem's passed the baton over to me to investigate, so I've reviewed
and back-ported the last known version of your patchset. I'm happy to 
report that the 100% reproducable leak that we were seeing before
cannot be reproduced. As expected, given review of the code. I have 
not been able to test the final driver-specific patches from your 
patchset, but up to and including

[PATCH 12/18] param: simple locking for sysfs-writable charp parameters

they can all have a:

Tested-by: Phil Carmody <ext-phil.2.carmody@nokia.com>

I'm quite interested to see these pushed into the mainline so that I
can cherry-pick final versions for our internal tree, do you have any 
schedule for that?

Cheers,
Phil
