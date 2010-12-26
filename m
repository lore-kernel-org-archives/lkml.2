Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab0LZWIC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 17:08:02 -0500
Received: from lo.gmane.org ([80.91.229.12]:42719 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332Ab0LZWIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 17:08:00 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Niels <zorglub_olsen@hotmail.com>
Subject: Re: Slow disks.
Date: Sun, 26 Dec 2010 23:07:45 +0100
Message-ID: <if8ebj$nf8$1@dough.gmane.org>
References: <20101220141553.GA6088@bitwizard.nl>	<20101220190630.66084e1d@neptune.home>	<AANLkTi=VAJbVSzX_DH9_==a3RonLJmawYu3MzF-uqGXC@mail.gmail.com>	<20101222104306.GB30941@bitwizard.nl> <m3aajvz5na.fsf@intrepid.localdomain> <4D14BB36.1030304@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 0x4dd52733.adsl.cybercity.dk
User-Agent: KNode/0.10.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 December 2010 16:24, Michael Tokarev wrote:

[snip]
> The thing is, for these WD*EARS drivers, it is _vital_ to get
> proper alignment of all partitions and operations.  They've
> 4Kb sectors physically but report 512bytes sectors to the OS.
> It is _essential_ to ensure all partitions are aligned to the
> 4Kb sectors.  Be it LVM, raid-something, etc - each filesystem
> must start at a 4kb boundary at least, or else you'll see
> _dramatic_ write speed problems.
> 
> So.. check the whole storage stack and ensure proper alignment
> everywhere.  In particular, check that your partitions are not
> aligned to 63 sectors (512b), or starts at N+1 sector - the
> most problematic mode for these drives.
[snip]

I have several of these drives, in various sizes. They seem to be aligned to
63 as you mention:

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1              63      208844      104391   83  Linux
/dev/sda2          208845    19759949     9775552+  82  Linux swap / Solaris
/dev/sda3        19759950   215094284    97667167+  83  Linux
/dev/sda4       215094285   781417664   283161690   83  Linux

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1              63  1953520064   976760001   83  Linux


Is that bad?

What can I do to repair it?

What can I do to prevent it from happening again?


Thanks,
Niels




