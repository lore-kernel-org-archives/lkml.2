Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab0DMInO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 04:43:14 -0400
Received: from gmp-eb-inf-2.sun.com ([192.18.6.24]:34231 "EHLO
	gmp-eb-inf-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab0DMInM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 04:43:12 -0400
X-Greylist: delayed 799 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Apr 2010 04:43:12 EDT
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Date: Tue, 13 Apr 2010 10:29:41 +0200
From: =?iso-8859-1?Q?H=E5kon_Bugge?= <Haakon.Bugge@Sun.COM>
Subject: Re: [PATCH] ummunotify: Userspace support for MMU notifications
In-reply-to: <20100412235937.GF15629@obsidianresearch.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Eric B Munson <ebmunson@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-rdma@vger.kernel.org, rolandd@cisco.com, peterz@infradead.org,
       pavel@ucw.cz, mingo@elte.hu
Message-id: <3251DDDA-D705-4B1E-9595-9C24709EF146@Sun.com>
X-Mailer: Apple Mail (2.1078)
Content-transfer-encoding: 8BIT
References: <1271053337-7121-1-git-send-email-ebmunson@us.ibm.com>
 <20100412160359.1d9074dc.akpm@linux-foundation.org>
 <20100412235937.GF15629@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 13, 2010, at 1:59 , Jason Gunthorpe wrote:

> On Mon, Apr 12, 2010 at 04:03:59PM -0700, Andrew Morton wrote:
> 
>>> As discussed in <http://article.gmane.org/gmane.linux.drivers.openib/61925>
>>> and follow-up messages, libraries using RDMA would like to track
>>> precisely when application code changes memory mapping via free(),
>>> munmap(), etc.  Current pure-userspace solutions using malloc hooks
>>> and other tricks are not robust, and the feeling among experts is that
>>> the issue is unfixable without kernel help.

I am not sure I agree with the premises here. ptMalloc and malloc hooks are not related to the issue in my opinion. User space library calls do not change virtual to physical mapping, system calls do. The following sys calls might change virtual to physical mapping: munmap(), mremap(), sbrk(), madvice(). What we need is glibc to provide hooks for these 4 sys calls and the general syscall() when its argument is one of the four mentioned syscalls. To me, that is what is needed, and the ummunotify direction seems way too complicated to me.

It is further claimed that "… other tricks are not robust". I wrote the code used in Scali/Platform MPI handling the issue. I do not think its fair to claim that this MPI  is not robust in this matter nor that is performance is bad.


Thanks, Håkon


