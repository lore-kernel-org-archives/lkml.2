Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab1IUF5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 01:57:25 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:32857 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab1IUF5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 01:57:21 -0400
Date: Tue, 20 Sep 2011 22:57:09 -0700
From: Kent Overstreet <kent.overstreet@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, rdunlap@xenotime.net, axboe@kernel.dk,
        akpm@linux-foundation.org, neilb@suse.de
Subject: Re: [GIT] Bcache version 12
Message-ID: <20110921055708.GB6601@moria>
References: <20110910064531.GA32536@moria>
 <CAOJsxLFPODubVEB3Tjg54C7jDKM8H-RCM_u5kvO1D0kKyjUYXQ@mail.gmail.com>
 <20110921025545.GB5521@moria>
 <CAOJsxLHQdf-+HuwVsQtF26oY_oJf3BsVdDi3NyJDi7F0eD03Gw@mail.gmail.com>
 <CAOJsxLGWoGqdv=tdBwWjM9-MD_Qm3ibMSGpp1j-tQLjMW-b-0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLGWoGqdv=tdBwWjM9-MD_Qm3ibMSGpp1j-tQLjMW-b-0A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 08:42:01AM +0300, Pekka Enberg wrote:
> On Wed, Sep 21, 2011 at 5:55 AM, Kent Overstreet
> > <kent.overstreet@gmail.com> wrote:
> >> Short version: bcache is for making IO faster.
> 
> On Wed, Sep 21, 2011 at 8:33 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > That's helpful...
> 
> Your documentation isn't helpful either:
> 
> +Say you've got a big slow raid 6, and an X-25E or three. Wouldn't it be
> +nice if you could use them as cache... Hence bcache.
> 
> So it's a cool hack but you fail to explain why someone wants to use
> it. You also fail to explain why you decided to implement it the way
> you did instead of making it more like fscache, for example.
> 
> Really, why do I need to go digging for this sort of information? It
> feels almost as if you don't want people to review your code...

The documentation should be better and better organized to be sure, but
I'm honestly not sure what's so strange about the concept of a cache for
block devices..

My changelog messages are certainly lousy but they aren't really the
place for a design doc, if that's what you're looking for.

As for bcache's design vs. fscache's design... well, they're so unlike
each other I'm not sure it even makes much sense to go into much.

Bcache caches block devices, fscache caches at the filesystem layer.
They each have uses where the other can't be used.

If you want more than that - IMO bcache's design is simpler, higher
performing, and more flexible.

bcache doesn't have to have a notion of files; it caches extents.

It can cache filesystem metadata - it can cache anything.

Because bcache has its own superblock (much like md), it can guarantee
that bcache devices are consistent; this is particularly important if
you want to do writeback caching. You really don't want to accidently
mount a filesystem that you were doing writeback caching on without the
ache - bcache makes it impossible to do so accidently.

Is any of that useful?
