Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab1FLLV3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 07:21:29 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:47083 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab1FLLV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 07:21:26 -0400
Date: Sun, 12 Jun 2011 13:21:24 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Jaroslaw Fedewicz <jafd@netstyle.com.ua>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Dave Airlie <airlied@linux.ie>
Subject: Re: drm-radeon failures on R600: patches still don't work
Message-ID: <20110612112124.GB1712@x4.trippels.de>
References: <BANLkTikzmp0BLefUPiiHZpK+48MYPeRE3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikzmp0BLefUPiiHZpK+48MYPeRE3A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.06.12 at 13:48 +0300, Jaroslaw Fedewicz wrote:
> 
> There was a recent thread as found on
> https://lkml.org/lkml/2011/6/8/17, started by Markus Trippelsdorf:
> 
> > The merge of the 'drm-radeon' branch by Linus yesterday breaks my setup
> > (RS780). The mouse cursor is just a black block suddenly and I see an
> > endless stream of:
> > radeon 0000:01:05.0: r600_check_texture_resource:1338 texture invalid format 26
> > [drm:radeon_cs_ioctl] *ERROR* Invalid command stream !
> 
> This is also true of my laptop (Thinkpad Edge 13, AMD model) which has
> built-in Radeon HD3200 (RS780) inside, and the most recent kernel from
> git.
> 
> Unfortunately, none of the patches proposed so far worked. The patch
> by Markus (https://lkml.org/lkml/2011/6/8/19) did work in the sense
> that X actually started up, but all graphics were very sluggish
> including mouse movements, to the point of unability to do anything
> remotely useful on that machine, and a patch proposed by Dave Airlie
> (https://lkml.org/lkml/2011/6/8/117) didn't apply - it comes out the
> line it added was already in the code.

Hmm, maybe you're seeing a different problem. The issue that I saw was
fixed by commit 428c6e3630 in the git tree (this is identical to the
patch by Dave you're referring to above).

Does a "git-revert fe6f0bd03d697835e76dd18d232ba476c65b8282" solve your
problem?

> I'm not a kernel hacker by any means, so sorry if I understood
> anything wrong; if I need to supply any additional information, I'll
> be glad to.

It would be great if you could git-bisect the issue. Basically you just
need to run:

git bisect start
git bisect bad
git bisect good ecff4fcc7bbaf060646d2160123f8dc02605a047

build new kernel
(reboot)
and then run either "git bisect good" or "git bisect bad", depending on
whether you see the problem or not, and then repeat the last 3 items in
the list. (please see also "man git-bisect")

> Also, sorry for not continuing that thread; I have just subscribed so
> I can't "reply" to it.

(That's no problem. But it is always a good idea to CC the people that
you're talking about and also the dri-devel list in this case)

-- 
Markus
