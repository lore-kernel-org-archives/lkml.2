Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547Ab0D3Rzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:55:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60147 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758905Ab0D3Ryw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:54:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [PATCH 2/8] PM: suspend_block: Add driver to access suspend blockers from user-space
Date: Thu, 29 Apr 2010 23:11:27 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Jim Collar <jim.collar@eqware.net>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, Avi Kivity <avi@redhat.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Magnus Damm <damm@igel.co.jp>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       Nigel Cunningham <nigel@tuxonice.net>, linux-doc@vger.kernel.org
References: <1272429119-12103-1-git-send-email-arve@android.com> <201004290105.15707.rjw@sisk.pl> <h2jd6200be21004281638y6b751abesfcf6416707e6fee4@mail.gmail.com>
In-Reply-To: <h2jd6200be21004281638y6b751abesfcf6416707e6fee4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004292311.27400.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 April 2010, Arve Hjønnevåg wrote:
> 2010/4/28 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Thursday 29 April 2010, Arve Hjønnevåg wrote:
> >> 2010/4/28 Rafael J. Wysocki <rjw@sisk.pl>:
> >> > On Wednesday 28 April 2010, Arve Hjønnevåg wrote:
> >> >> Add a misc device, "suspend_blocker", that allows user-space processes
> >> >> to block auto suspend. The device has ioctls to create a suspend_blocker,
> >> >> and to block and unblock suspend. To delete the suspend_blocker, close
> >> >> the device.
> >> >>
> >> >> Signed-off-by: Arve Hjønnevåg <arve@android.com>
> >> > ...
> >> >> +
> >> >> +#include <linux/fs.h>
> >> >> +#include <linux/miscdevice.h>
> >> >> +#include <linux/module.h>
> >> >> +#include <linux/uaccess.h>
> >> >> +#include <linux/slab.h>
> >> >> +#include <linux/suspend_blocker.h>
> >> >> +#include <linux/suspend_block_dev.h>
> >> >> +
> >> >> +enum {
> >> >> +     DEBUG_FAILURE   = BIT(0),
> >> >> +};
> >> >> +static int debug_mask = DEBUG_FAILURE;
> >> >
> >> > What's the exact purpose of this?
> >>
> >> To show errors returned to user space. I can turn it off by default if you want.
> >
> > Not necessarily, but why is it a mask?  It looks like a 0/1 thing would be
> > sufficient.
> 
> I may want to add a bit to print all user-space block and unblock calls.

Alternatively, you can add a new parameter for that, which I think I would prefer.

Rafael
