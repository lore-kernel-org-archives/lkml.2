Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935Ab2FPAdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 20:33:22 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:48151 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758478Ab2FPAdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 20:33:21 -0400
X-Greylist: delayed 719 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jun 2012 20:33:21 EDT
X-ASG-Debug-ID: 1339806081-0421b53abf07010001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Fri, 15 Jun 2012 20:21:19 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs updates
Message-ID: <20120616002119.GI19150@shiny>
X-ASG-Orig-Subj: Re: [GIT PULL] Btrfs updates
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20120615180957.GE19150@shiny>
 <CA+55aFzD3P=DxzqhtRC6jRi9kwHiWRJo=yvyY=WnhYnhXvFi0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFzD3P=DxzqhtRC6jRi9kwHiWRJo=yvyY=WnhYnhXvFi0w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1339806081
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.99966
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 05:57:42PM -0600, Linus Torvalds wrote:
> On Fri, Jun 15, 2012 at 11:09 AM, Chris Mason <chris.mason@fusionio.com> wrote:
> >
> > Please pull my for-linus branch:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
> 
> This seems to introduce a new warning:
> 
>   In file included from fs/btrfs/ctree.c:22:0:
>   fs/btrfs/ctree.c: In function ‘btrfs_search_old_slot’:
>   fs/btrfs/ctree.h:2117:240: warning: ‘old_generation’ may be used
> uninitialized in this function [-Wmaybe-uninitialized]
>   fs/btrfs/ctree.c:1178:6: note: ‘old_generation’ was declared here
> 
> which looks like just gcc being unable to see that it is only used
> when set, but it's still annoying. I'd suggest initializing it to 0
> just to shut up the compiler. Ok?
> 

Yes, this does look like noise.  It is only used when old_root is set,
but it'll be really easy to add bugs there later.

I've pushed two commits out, the second one is a printk cast on 32 bit
machines.  Neither of these are fatal but they are in for-linus:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Chris Mason (2) commits (+3/-2):
    Btrfs: cast devid to unsigned long long for printk %llu (+2/-1)
    Btrfs: init old_generation in get_old_root (+1/-1)

Total: (2) commits (+3/-2)

 fs/btrfs/ctree.c |    2 +-
 fs/btrfs/ioctl.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)
