Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab0DMR5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 13:57:42 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:2087 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab0DMR5k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 13:57:40 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.52,198,1270425600"; 
   d="scan'208";a="114620388"
From: Roland Dreier <rdreier@cisco.com>
To: =?utf-8?Q?H=C3=A5kon?= Bugge <Haakon.Bugge@Sun.COM>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric B Munson <ebmunson@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-rdma@vger.kernel.org, rolandd@cisco.com, peterz@infradead.org,
       pavel@ucw.cz, mingo@elte.hu, jsquyres@cisco.com
Subject: Re: [PATCH] ummunotify: Userspace support for MMU notifications
References: <1271053337-7121-1-git-send-email-ebmunson@us.ibm.com>
	<20100412160359.1d9074dc.akpm@linux-foundation.org>
	<20100412235937.GF15629@obsidianresearch.com>
	<3251DDDA-D705-4B1E-9595-9C24709EF146@Sun.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 13 Apr 2010 10:57:32 -0700
In-Reply-To: <3251DDDA-D705-4B1E-9595-9C24709EF146@Sun.com> (=?utf-8?Q?=22?=
 =?utf-8?Q?H=C3=A5kon?= Bugge"'s
	message of "Tue, 13 Apr 2010 10:29:41 +0200")
Message-ID: <adahbnfme0j.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I am not sure I agree with the premises here. ptMalloc and malloc
 > hooks are not related to the issue in my opinion. User space library
 > calls do not change virtual to physical mapping, system calls do. The
 > following sys calls might change virtual to physical mapping:
 > munmap(), mremap(), sbrk(), madvice(). What we need is glibc to
 > provide hooks for these 4 sys calls and the general syscall() when
 > its argument is one of the four mentioned syscalls. To me, that is
 > what is needed, and the ummunotify direction seems way too
 > complicated to me.

Are those system calls the only possible way that virtual to physical
mappings can change?  Can't page migration or something like that
potentially affect things?  And even if you did have hooks into every
system call that mattered (keep in mind that relying on glibc is not
enough, since an MPI application may not use glibc) would decoding them
and figuring out what happened really be preferable to a single event
type that tells you exactly what address range was affected?

 > It is further claimed that "… other tricks are not robust". I wrote
 > the code used in Scali/Platform MPI handling the issue. I do not
 > think its fair to claim that this MPI is not robust in this matter
 > nor that is performance is bad.

The Open MPI developers have spent a lot of effort trying to handle this
purely in userspace and still do not believe that a truly robust
solution is possible without kernel help.  Perhaps they can expand on
what the obstacles are.

 - R.
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
