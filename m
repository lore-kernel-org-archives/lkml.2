Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab0EZV4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 17:56:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44651 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab0EZV4E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 17:56:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Zijlstra <peterz@infradead.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH 2/8] PM: suspend_block: Add driver to access suspend blockers from user-space
Date: Wed, 26 May 2010 23:57:28 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-tst; KDE/4.3.5; x86_64; ; )
Cc: Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Jim Collar <jim.collar@eqware.net>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, Avi Kivity <avi@redhat.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Magnus Damm <damm@igel.co.jp>, Nigel Cunningham <nigel@tuxonice.net>,
       linux-doc@vger.kernel.org
References: <1274482015-30899-1-git-send-email-arve@android.com> <1274482015-30899-3-git-send-email-arve@android.com> <1274863428.5882.4860.camel@twins>
In-Reply-To: <1274863428.5882.4860.camel@twins>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005262357.28933.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 May 2010, Peter Zijlstra wrote:
> On Fri, 2010-05-21 at 15:46 -0700, Arve Hjønnevåg wrote:
> > +To create a suspend blocker from user space, open the suspend_blocker
> > special
> > +device file:
> > +
> > +    fd = open("/dev/suspend_blocker", O_RDWR | O_CLOEXEC);
> > +
> > +then optionally call:
> > +
> > +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_SET_NAME(strlen(name)), name);
> > +
> > +To activate the suspend blocker call:
> > +
> > +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_BLOCK);
> > +
> > +To deactivate it call:
> > +
> > +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_UNBLOCK);
> > +
> > +To destroy the suspend blocker, close the device:
> > +
> > +    close(fd);
> 
> Urgh, please let the open() be BLOCK, the close() be UNBLOCK, and keep
> the SET_NAME thing if you really care.

SET_NAME wouldn't serve any purpose in that case.

This whole thing is related to the statistics part, which Arve says is
essential to him.  He wants to collect statistics for each suspend blocker
activated and deactivated so that he can tell who's causing problems by
blocking suspend too often.  The name also is a part of this.

In fact, without the statistics part the whole thing might be implemented
as a single reference counter such that suspend would happen when it went down
to zero.

Thanks,
Rafael
