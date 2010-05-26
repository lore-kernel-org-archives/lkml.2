Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab0EZLGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 07:06:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52131 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab0EZLGr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 07:06:47 -0400
Subject: Re: [PATCH 2/8] PM: suspend_block: Add driver to access suspend 
 blockers from user-space
From: Peter Zijlstra <peterz@infradead.org>
To: Florian Mickler <florian@mickler.org>
Cc: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Jim Collar <jim.collar@eqware.net>, Greg Kroah-Hartman <gregkh@suse.de>,
       Avi Kivity <avi@redhat.com>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Magnus Damm <damm@igel.co.jp>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Nigel Cunningham <nigel@tuxonice.net>, linux-doc@vger.kernel.org
In-Reply-To: <20100526125136.53f2dc82@schatten.dmk.lab>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	 <1274482015-30899-2-git-send-email-arve@android.com>
	 <1274482015-30899-3-git-send-email-arve@android.com>
	 <1274863428.5882.4860.camel@twins>
	 <AANLkTimTnzK1ByG2bE2gGjINxD_Pbvez7PFHo7Kzo9yk@mail.gmail.com>
	 <20100526125136.53f2dc82@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 May 2010 13:06:25 +0200
Message-ID: <1274871985.5882.5373.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-26 at 12:51 +0200, Florian Mickler wrote:
> On Wed, 26 May 2010 03:47:27 -0700
> Arve Hjønnevåg <arve@android.com> wrote:
> 
> > 2010/5/26 Peter Zijlstra <peterz@infradead.org>:
> > > On Fri, 2010-05-21 at 15:46 -0700, Arve Hjønnevåg wrote:
> > >> +To create a suspend blocker from user space, open the suspend_blocker
> > >> special
> > >> +device file:
> > >> +
> > >> +    fd = open("/dev/suspend_blocker", O_RDWR | O_CLOEXEC);
> > >> +
> > >> +then optionally call:
> > >> +
> > >> +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_SET_NAME(strlen(name)), name);
> > >> +
> > >> +To activate the suspend blocker call:
> > >> +
> > >> +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_BLOCK);
> > >> +
> > >> +To deactivate it call:
> > >> +
> > >> +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_UNBLOCK);
> > >> +
> > >> +To destroy the suspend blocker, close the device:
> > >> +
> > >> +    close(fd);
> > >
> > > Urgh, please let the open() be BLOCK, the close() be UNBLOCK, and keep
> > > the SET_NAME thing if you really care.
> > >
> > 
> > That would be very inefficient.
> > 
> 
> Also I think it is intended to enforce named suspend blockers. (For
> debugging/accounting purposes).

I don't think the code as proposed mandates you SET_NAME, and I didn't
propose killing that off, you can still SET_NAME after you open() and
acquire the thing.

Anyway, the whole point is moot since its simply not needed at all.
