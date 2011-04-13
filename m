Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933366Ab1DMWaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 18:30:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49151 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933313Ab1DMWaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 18:30:13 -0400
Date: Wed, 13 Apr 2011 15:30:05 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Mark Lord <kernel@teksavvy.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: Re: CONFIG_EXT4_USE_FOR_EXT23:  rootfs shows as ext2 instead of
 ext4
Message-ID: <20110413223005.GB6821@noexit>
Mail-Followup-To: Theodore Tso <tytso@MIT.EDU>,
	Mark Lord <kernel@teksavvy.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
References: <4DA48AF4.5080803@teksavvy.com>
 <20110413004938.GE3682@thunk.org>
 <4DA5AEBE.6060705@teksavvy.com>
 <5A35771F-49B6-491E-B012-DBE68907E382@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5A35771F-49B6-491E-B012-DBE68907E382@mit.edu>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 05:00:34PM -0400, Theodore Tso wrote:
> I can write up a patch which explicitly tests for feature flags that go
> beyond ext2 as of a particular version, and if so, refuse the mount
> when ext4 is masquerading as ext2, and do the same for ext3.   I
> probably will do this to avoid user questions, when I have some 
> spare time.

	This is the correct behavior.  Few people understand the
filesystem type test ordering, and fewer (these days) modify their own
.config.  They expect that the name in /proc/mounts reflects the format
on the platter.  If we say 'ext2', they think it's a non-journaled FFS.
	Errors in the other direction are less confusing.  If you wanted
a quick hack, you could just have ext4 always fail ext2/3 mounts and
report itself as ext4 no matter what the physical disk looks like.
People would understand that 'ext4' in /proc/mounts means that the ext4
driver has mounted an extN filesystem much faster than they would
understand that 'ext2' means the ext4 driver has mounted an ext4
filesystem but with the scanning name of ext2.

Joel

-- 

"If at first you don't succeed, cover all traces that you tried."
                                                        -Unknown

			http://www.jlbec.org/
			jlbec@evilplan.org
