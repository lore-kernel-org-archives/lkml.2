Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab0DWS2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 14:28:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37511 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab0DWS2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 14:28:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: document open(/dev/snapshot) sideeffects -- was Re: [linux-pm] syncing the disks when entering sleep
Date: Fri, 23 Apr 2010 20:28:55 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: "Leisner, Martin" <Martin.Leisner@xerox.com>,
       linux-pm@lists.linux-foundation.org, Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>
References: <76FA3B279DD9DA48896E2B404944957204E0B241@USA7061MS02.na.xerox.net> <201001281143.08993.rjw@sisk.pl> <20100405063852.GA1924@elf.ucw.cz>
In-Reply-To: <20100405063852.GA1924@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004232028.56005.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 April 2010, Pavel Machek wrote:
> Hi!
> 
> > > > Please note that merely _opening_ /dev/snapshot has side effects, so that's
> > > > not just "three ioctls".
> > > 
> > > I search Doc*/power/userland-swsusp.txt, and could not find mentions
> > > of sideeffects. Perhaps that should be fixed?
> > 
> > Please feel free to make the docs more complete, then.
> 
> Yes, something like this?

Yes, looks reasonable.

I've applied it to suspend-2.6/linux-next (added a changelog).

Rafael


> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> --- a/Documentation/power/userland-swsusp.txt
> +++ b/Documentation/power/userland-swsusp.txt
> @@ -24,6 +24,10 @@ assumed to be in the resume mode.  The device cannot be open for simultaneous
>  reading and writing.  It is also impossible to have the device open more than
>  once at a time.
>  
> +Even opening the device has side effects. Data structures are
> +allocated, and PM_HIBERNATION_PREPARE / PM_RESTORE_PREPARE chains are
> +called.
> +
>  The ioctl() commands recognized by the device are:
>  
>  SNAPSHOT_FREEZE - freeze user space processes (the current process is
> 
> 
> 
> 

