Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab2LSLco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 06:32:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab2LSLcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 06:32:36 -0500
Date: Wed, 19 Dec 2012 09:30:39 -0200
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: qemu-devel@nongnu.org, riel@redhat.com, aquini@redhat.com, mst@redhat.com,
        amit.shah@redhat.com, agl@us.ibm.com,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Glauber Costa <glommer@parallels.com>, Michal Hocko <mhocko@suse.cz>,
        kirill@shutemov.name, Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 3/3] virtio-balloon: add auto-ballooning support
Message-ID: <20121219093039.51831f6f@doriath.home>
In-Reply-To: <20121218225330.GA28297@lizard.mcd00620.sjc.wayport.net>
References: <1355861815-2607-1-git-send-email-lcapitulino@redhat.com>
	<1355861815-2607-4-git-send-email-lcapitulino@redhat.com>
	<20121218225330.GA28297@lizard.mcd00620.sjc.wayport.net>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2012 14:53:30 -0800
Anton Vorontsov <anton.vorontsov@linaro.org> wrote:

> Hello Luiz,
> 
> On Tue, Dec 18, 2012 at 06:16:55PM -0200, Luiz Capitulino wrote:
> > The auto-ballooning feature automatically performs balloon inflate
> > or deflate based on host and guest memory pressure. This can help to
> > avoid swapping or worse in both, host and guest.
> > 
> > Auto-ballooning has a host and a guest part. The host performs
> > automatic inflate by requesting the guest to inflate its balloon
> > when the host is facing memory pressure. The guest performs
> > automatic deflate when it's facing memory pressure itself. It's
> > expected that auto-inflate and auto-deflate will balance each
> > other over time.
> > 
> > This commit implements the host side of auto-ballooning.
> > 
> > To be notified of host memory pressure, this commit makes use of this
> > kernel API proposal being discussed upstream:
> > 
> >  http://marc.info/?l=linux-mm&m=135513372205134&w=2
> 
> Wow, you're fast! And I'm glad that it works for you, so we have two
> full-featured mempressure cgroup users already.

Thanks, although I think we need more testing to be sure this does what
we want. I mean, the basic mechanics does work, but my testing has been
very light so far.

> Even though it is a qemu patch, I think we should Cc linux-mm folks on it,
> just to let them know the great news.

I'll do it next time.
