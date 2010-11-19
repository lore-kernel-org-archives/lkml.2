Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab0KSPov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 10:44:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396Ab0KSPot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 10:44:49 -0500
Date: Fri, 19 Nov 2010 16:44:33 +0100 (CET)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-lab-213.englab.brq.redhat.com
To: Mark Lord <kernel@teksavvy.com>
cc: "Ted Ts'o" <tytso@mit.edu>, Steven Whitehouse <swhiteho@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
        Josef Bacik <josef@redhat.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        sandeen@redhat.com
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
In-Reply-To: <4CE69940.6040908@teksavvy.com>
Message-ID: <alpine.LFD.2.00.1011191640320.3238@dhcp-lab-213.englab.brq.redhat.com>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com> <20101118130630.GJ6178@parisc-linux.org> <20101118134804.GN5618@dhcp231-156.rdu.redhat.com> <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org>
 <1290100750.3041.72.camel@mulgrave.site> <alpine.LFD.2.00.1011181826550.15886@dhcp-lab-213.englab.brq.redhat.com> <1290168976.2570.45.camel@dolmen> <4CE68155.50705@teksavvy.com> <20101119140203.GC10039@thunk.org> <4CE69940.6040908@teksavvy.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Nov 2010, Mark Lord wrote:

> On 10-11-19 09:02 AM, Ted Ts'o wrote:
> > but that's why mount -o discard is not the default.
> 
> 
> But, oddly, it _is_ the default for mke2fs -t ext4,
> which really threw me for a loop recently.
> 
> I though my system had locked up when suddenly everything
> went dead for a very long time (many minutes) while installing a new system.
> 
> Then I figured out what was going on.
> I really believe that "-K" should be the _default_ for mke2fs,
> as otherwise lots of other people probably also wonder
> if Linux is killing their SSD at system install time..
> 
> Cheers
> 

That is exactly a reason why I posted a patch for
"Make blkdev_issue_discard() interruptible", but nobody seems to care. As
an addition I have patched mke2fs to inform user about ongoing discard,
also with not much attention (Ted?).


Thanks!
-Lukas
