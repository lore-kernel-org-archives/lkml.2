Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab2KPMXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 07:23:47 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42743 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2KPMXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 07:23:46 -0500
Date: Fri, 16 Nov 2012 13:24:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 3.7-rc3: mouses stopped working
Message-ID: <20121116122400.GA10994@elf.ucw.cz>
References: <20121115132849.GA4062@elf.ucw.cz>
 <alpine.LNX.2.00.1211151429240.15877@pobox.suse.cz>
 <20121115140736.GA2651@elf.ucw.cz>
 <alpine.LNX.2.00.1211151508350.15877@pobox.suse.cz>
 <20121116013405.GA2002@elf.ucw.cz>
 <alpine.LNX.2.00.1211161153290.20577@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1211161153290.20577@pobox.suse.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2012-11-16 11:54:26, Jiri Kosina wrote:
> On Fri, 16 Nov 2012, Pavel Machek wrote:
> 
> > > If you have mouse that is buggy and periodically 
> > > disconnecting/reconnecting itself, you need commit df0cfd6990347c, which 
> > > went into 3.7-rc5 (it's a regression fix from -rc1).
> > 
> > I have -rc5 now, and still no mice for me.
> > 
> > root@amd:/tmp# uname -a
> > Linux amd 3.7.0-rc5+ #236 SMP Thu Nov 15 20:07:26 CET 2012 i686 GNU/Linux
> > root@amd:/tmp# cat /dev/input/mice
> > cat: /dev/input/mice: No such device or address
> > root@amd:/tmp# ls -al /dev/input/mice
> > crw-rw---- 1 root root 13, 63 Apr 25  2010 /dev/input/mice
> > root@amd:/tmp# 
> 
> Let's see whether this is /dev/input/mice issue or something else first.
> 
> Is anything coming out of corresponding /dev/input/eventX node?

/dev/input/mouse0 and /dev/input/mouse1 generate events when I move
internal/USB mouse.

ls -al /dev/input/mouse0 
crw-rw---- 1 root root 13, 32 Apr 25  2010 /dev/input/mouse0
pavel@amd:/tmp$ ls -al /dev/input/mouse1
crw------T 1 root root 13, 33 Aug 30 16:41 /dev/input/mouse1
pavel@amd:/tmp$ 

> And /dev/hidrawX?

/dev/hidraw0 seems to correspond to USB mouse and generates
events. Could not find hidraw corresponding to PS/2 mouse.

So it seems to be "/dev/input/mice" issue. Does it work for you?

Thanks,
      	       	  		    	   	   Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
