Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934346Ab0EZKvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 06:51:43 -0400
Received: from ist.d-labs.de ([213.239.218.44]:53648 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077Ab0EZKvl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 06:51:41 -0400
Date: Wed, 26 May 2010 12:51:36 +0200
From: Florian Mickler <florian@mickler.org>
To: Arve =?ISO-8859-15?B?SGr4bm5lduVn?= <arve@android.com>
Newsgroups: gmane.linux.documentation,gmane.linux.kernel
Cc: Peter Zijlstra <peterz@infradead.org>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Jim Collar <jim.collar@eqware.net>, Greg Kroah-Hartman <gregkh@suse.de>,
       Avi Kivity <avi@redhat.com>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Magnus Damm <damm@igel.co.jp>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Nigel Cunningham <nigel@tuxonice.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/8] PM: suspend_block: Add driver to access suspend 
 blockers from user-space
Message-ID: <20100526125136.53f2dc82@schatten.dmk.lab>
In-Reply-To: <AANLkTimTnzK1ByG2bE2gGjINxD_Pbvez7PFHo7Kzo9yk@mail.gmail.com>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	<1274482015-30899-2-git-send-email-arve@android.com>
	<1274482015-30899-3-git-send-email-arve@android.com>
	<1274863428.5882.4860.camel@twins>
	<AANLkTimTnzK1ByG2bE2gGjINxD_Pbvez7PFHo7Kzo9yk@mail.gmail.com>
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 03:47:27 -0700
Arve Hjønnevåg <arve@android.com> wrote:

> 2010/5/26 Peter Zijlstra <peterz@infradead.org>:
> > On Fri, 2010-05-21 at 15:46 -0700, Arve Hjønnevåg wrote:
> >> +To create a suspend blocker from user space, open the suspend_blocker
> >> special
> >> +device file:
> >> +
> >> +    fd = open("/dev/suspend_blocker", O_RDWR | O_CLOEXEC);
> >> +
> >> +then optionally call:
> >> +
> >> +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_SET_NAME(strlen(name)), name);
> >> +
> >> +To activate the suspend blocker call:
> >> +
> >> +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_BLOCK);
> >> +
> >> +To deactivate it call:
> >> +
> >> +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_UNBLOCK);
> >> +
> >> +To destroy the suspend blocker, close the device:
> >> +
> >> +    close(fd);
> >
> > Urgh, please let the open() be BLOCK, the close() be UNBLOCK, and keep
> > the SET_NAME thing if you really care.
> >
> 
> That would be very inefficient.
> 

Also I think it is intended to enforce named suspend blockers. (For
debugging/accounting purposes).

Cheers,
Flo
