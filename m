Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab2IJN6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 09:58:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58803 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab2IJN6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 09:58:10 -0400
Date: Mon, 10 Sep 2012 10:58:04 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: 3.4.10 i915 [GM45] regression
Message-ID: <20120910135803.GB2972@herton-Z68MA-D2H-B3>
References: <2372445.fuIXicT4H0@tux200s>
 <20120907011542.GA26688@kroah.com>
 <2329337.9aFzn0oRxF@tux200s>
 <CAKMK7uHqk1x4dM9ZA0usskNoArR6eTFmEtVw+_juzVq1NeYg+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uHqk1x4dM9ZA0usskNoArR6eTFmEtVw+_juzVq1NeYg+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 11:37:27AM +0200, Daniel Vetter wrote:
> On Fri, Sep 7, 2012 at 3:57 AM, Andreas Sturmlechner
> <andreas.sturmlechner@gmail.com> wrote:
> >> On Fri, Sep 07, 2012 at 02:27:12AM +0200, Andreas Sturmlechner wrote:
> >> > Hello,
> >> >
> >> > please revert commit 0d8957c8a90bbb5d34fab9a304459448a5131e06 - for some
> >> > reason it breaks boot-up (screen stays blank) on my GM45 hardware despite
> >> > >= 3.5 being fine.
> >> >
> >> > See bug 54575 on freedesktop.org for a full description:
> >> > https://bugs.freedesktop.org/show_bug.cgi?id=54575
> >> >
> >> > No idea how far-spread or not this might be since I couldn't find any
> >> > other reports of that kind.
> >>
> >> Can you cc: this to the people who wrote that patch?  That might help in
> >> figuring out what is wrong here...
> 
> drm/i915 cat-herder here - I have no idea what's going on :( Things
> seem to work on 3.5, I haven't gotten any regression reports for gm45
> on 3.5 (and these boxes are rather popular). And all the people who
> reported issues with this patch on 3.4 had no such problems on 3.5
> (with the same patch applied).
> 
> And I've looked again at the patches in that area and don't see what
> could be missing. Hence I guess we should just revert this patch from
> 3.4.

Couldn't it be that it happens because 3.4 doesn't have commits
b7884eb45ec98c0d34c7f49005ae9d4b4b4e38f6 and
f01db988ef6f6c70a6cc36ee71e4a98a68901229 applied? May be they are needed
after all.

Andreas, also make sure your hardware in the bios is configured within
the memory types supported by GM45 (DDR2-667/800, DDR3-800/1066, from
Intel website listed specifications). I had a similar problem on a G41
machine with same commit, with a pair of DDR3-1333 memory installed it
was configured to run at 1333, but the chipset only supports up to 1066,
when I forced it back to DDR3-1066 in the bios, the problem vanished.
"Funny" that commit 0d8957c8a9 triggered the issue reliably.

> 
> Thanks, Daniel
> -- 
> Daniel Vetter
> daniel.vetter@ffwll.ch - +41 (0) 79 364 57 48 - http://blog.ffwll.ch
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
[]'s
Herton
