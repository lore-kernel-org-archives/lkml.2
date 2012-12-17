Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751116Ab2LQCBy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 21:01:54 -0500
Received: from mx1.fusionio.com ([66.114.96.30]:34151 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab2LQCBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 21:01:52 -0500
X-ASG-Debug-ID: 1355709711-03d6a508b8269d80001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Sun, 16 Dec 2012 21:01:49 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Chris Mason <clmason@fusionio.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        Josef Bacik <JBacik@fusionio.com>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the btrfs tree
Message-ID: <20121217020149.GB13828@shiny>
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
X-Barracuda-Start-Time: 1355709711
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.117224
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

Many thanks Stephen for helping debug this.

It turned out to be the size of the ioctl arg was just too big.  Stefan,
I lowered this by using BTRFS_DEVICE_PATH_NAME_MAX instead, and I also
put the char arrays after the u64s.

It works here with the progs patch you sent (and matching struct
changes), including cancel and the btrfs replace -r mode.  I've pushed
the result out to my next branch and my for-linus branch, please take a
look and make sure I didn't miss anything.

-chris
