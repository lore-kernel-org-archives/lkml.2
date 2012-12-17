Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab2LQAPJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 19:15:09 -0500
Received: from mx1.fusionio.com ([66.114.96.30]:48099 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab2LQAPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 19:15:07 -0500
X-ASG-Debug-ID: 1355703305-03d6a50cb5df4e30001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Sun, 16 Dec 2012 19:15:04 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Chris Mason <clmason@fusionio.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        Josef Bacik <JBacik@fusionio.com>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the btrfs tree
Message-ID: <20121217001504.GA13828@shiny>
X-ASG-Orig-Subj: Re: linux-next: build failure after merge of the btrfs tree
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Chris Mason <clmason@fusionio.com>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Stefan Behrens <sbehrens@giantdisaster.de>,
	Josef Bacik <JBacik@fusionio.com>,
	Linus <torvalds@linux-foundation.org>
References: <20121217100022.7d751dc9075d60a33d636a23@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121217100022.7d751dc9075d60a33d636a23@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1355703305
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0181 1.0000 -1.9032
X-Barracuda-Spam-Score: -1.90
X-Barracuda-Spam-Status: No, SCORE=-1.90 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.117216
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 04:00:22PM -0700, Stephen Rothwell wrote:
> Hi Chris,
> 
> After merging the btrfs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> fs/btrfs/ioctl.c: In function 'btrfs_ioctl':
> fs/btrfs/ioctl.c:3940:7: error: case label does not reduce to an integer constant

Thanks Stephen.  In my sources, this line is:

case BTRFS_IOC_DEV_REPLACE:

And the define is:

#define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
                                    struct btrfs_ioctl_dev_replace_args)

Is there a way to see what ppc64 is doing with this macro?

> 
> Caused by commit 0aa7cbc7585a ("Btrfs: add support for device replace ioctls").
> 
> I have used the btrfs tree from next-20121214 for today (which was empty).
> 
> I have to say that these btrfs commits have come to linux-next very late
> in the game (i.e. some of them have author dates back in September and
> October and yet they only appeared in linux-next today).

This is true, we've had these in testing for some time.  Especially when
new interfaces come in, we tend to delay them.

> Also, the
> committer of this commits is Josef Bacik <jbacik@fusionio.com> but there
> is not Signed-off-by him.  There are other commits that are committed by
> you, Chris, that also do not have a Signed-off-by you.

Josef and I have sob on all of our commits (at least all the ones not in
3.7, I didn't go back farther).  In this case the Author was Stefan and
it ended up rebased in either Josef's or my tree.  We usually try to
preserve merges on rebase, but this time was a bigger set of changes
than usual and it didn't work out.

-chris

