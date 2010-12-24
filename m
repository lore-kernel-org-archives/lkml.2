Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab0LXObF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 09:31:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39364 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab0LXObD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 09:31:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=WA6/9qRhw5ref7s/VqzAo6wW1yb7JtYNHJ0fSzop10kxPIzPulaf2hF7nvt0csBdHg
         N7qe2Or8CYxr7fWXaLXoDL1I4hKHb+GfCo3SoaxubQuWFZHqwoSmX0NcGI3nlF7BJfe7
         fEg8b+EYxafx+3gPz69z4rH9/U2E8E42w4Fjw=
Date: Fri, 24 Dec 2010 15:30:58 +0100
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Yong Zhang <yong.zhang0@gmail.com>
Subject: [GIT PULL] percpu: fixes for v2.6.37-rc7
Message-ID: <20101224143058.GA11419@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from the following branch to receive percpu changes for
v2.6.37-rc7.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus

It contains two commits.  One to make init_kthread_work[er]() lockdep
friendly and add _ONSTACK variants of DEFINE macros.  This removes
spurious lockdep warnings from ivtv.

The other one lowers the priority of the percpu allocation table
printout from KERN_INFO to KERN_DEBUG.  As percpu don't usually cause
boot failures these days, having access to the information post-boot
is good enough.

Thanks.

Tejun Heo (1):
	percpu: print out alloc information with KERN_DEBUG instead of KERN_INFO

Yong Zhang (1):
	kthread_work: make lockdep happy

 include/linux/kthread.h |   45 +++++++++++++++++++++++++++++++++++----------
 kernel/kthread.c        |   11 +++++++++++
 mm/percpu.c             |    2 +-
 3 files changed, 47 insertions(+), 11 deletions(-)

-- 
tejun
