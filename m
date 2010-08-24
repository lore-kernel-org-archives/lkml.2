Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab0HXBUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 21:20:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55608 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab0HXBUP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 21:20:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Michael Rubin <mrubin@google.com>
Subject: Re: [PATCH 4/4] writeback: Reporting dirty thresholds in /proc/vmstat
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "jack@suse.cz" <jack@suse.cz>, "riel@redhat.com" <riel@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "npiggin@kernel.dk" <npiggin@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
In-Reply-To: <AANLkTikS+DUfPz0E2SmCZTQBWL8h2zSsGM8--yqEaVgZ@mail.gmail.com>
References: <20100821054808.GA29869@localhost> <AANLkTikS+DUfPz0E2SmCZTQBWL8h2zSsGM8--yqEaVgZ@mail.gmail.com>
Message-Id: <20100824100943.F3B6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 24 Aug 2010 10:20:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Aug 20, 2010 at 10:48 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> > On Fri, Aug 20, 2010 at 05:31:29PM +0800, Michael Rubin wrote:
> >> The kernel already exposes the user desired thresholds in /proc/sys/vm
> >> with dirty_background_ratio and background_ratio. But the kernel may
> >> alter the number requested without giving the user any indication that
> >> is the case.
> >>
> >> Knowing the actual ratios the kernel is honoring can help app developers
> >> understand how their buffered IO will be sent to the disk.
> >>
> >>       $ grep threshold /proc/vmstat
> >>       nr_dirty_threshold 409111
> >>       nr_dirty_background_threshold 818223
> >
> > I realized that the dirty thresholds has already been exported here:
> >
> > $ grep Thresh  /debug/bdi/8:0/stats
> > BdiDirtyThresh:     381000 kB
> > DirtyThresh:       1719076 kB
> > BackgroundThresh:   859536 kB
> >
> > So why not use that interface directly?
> 
> LOL. I know about these counters. This goes back and forth a lot.
> The reason we don't want to use this interface is several fold.

Please don't use LOL if you want to get good discuttion. afaict, Wu have
deep knowledge in this area. However all kernel-developer don't know all
kernel knob.

> 
> 1) It's exporting the implementation of writeback. We are doing bdi
> today but one day we may not.
> 2) We need a non debugfs version since there are many situations where
> debugfs requires root to mount and non root users may want this data.
> Mounting debugfs all the time is not always an option.

In nowadays, many distro mount debugfs at boot time. so, can you please
elaborate you worried risk?  even though we have namespace.


> 3) Full system counters are easier to handle the juggling of removable
> storage where these numbers will appear and disappear due to being
> dynamic.
> 
> The goal is to get a full view of the system writeback behaviour not a
> "kinda got it-oops maybe not" view.

I bet nobody oppose this point :)


