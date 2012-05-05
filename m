Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab2EESpA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 14:45:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002Ab2EESo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 14:44:59 -0400
Date: Sat, 5 May 2012 14:44:18 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Jiri Slaby <jslaby@suse.cz>
cc: Guy Martin <gmsof@tuxicoman.be>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert 5dd5bc40f3b6e0ccdaad948dbadc94ad0906cb25
In-Reply-To: <4FA4D93A.6090103@suse.cz>
Message-ID: <Pine.LNX.4.64.1205051443520.2623@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1205042250130.18896@file.rdu.redhat.com>
 <Pine.LNX.4.64.1205042259000.18896@file.rdu.redhat.com> <4FA4D93A.6090103@suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 5 May 2012, Jiri Slaby wrote:

> On 05/05/2012 05:04 AM, Mikulas Patocka wrote:
> > Hi
> > 
> > This patch reverts commit 5dd5bc40f3b6e0ccdaad948dbadc94ad0906cb25.
> > 
> > The commit 5dd5bc40f3b6e0ccdaad948dbadc94ad0906cb25 causes system lockup 
> > when pdc is used as a boot console.
> > 
> > The kernel boots, but it locks up when transferring control to userspace 
> > --- the message "INIT: version 2.86 booting" is not printed and the 
> > computer halts. With the patch reverted, the system starts normally on 
> > pdc.
> ...
> > --- a/arch/parisc/kernel/pdc_cons.c
> > +++ b/arch/parisc/kernel/pdc_cons.c
> ...
> > @@ -104,10 +103,8 @@ static int pdc_console_tty_open(struct tty_struct *tty, struct file *filp)
> >  
> >  static void pdc_console_tty_close(struct tty_struct *tty, struct file *filp)
> >  {
> > -	if (!tty->count) {
> > +	if (!tty->count)
> 
> Heh, I cannot find a bug in the patch proper. However this test is and
> always was bogus. Does changing "!tty->count" to "tty->count == 1" help?

Yes, it fixes it.

Mikulas

> >  		del_timer_sync(&pdc_console_timer);
> > -		tty_port_tty_set(&tty_port, NULL);
> > -	}
> >  }
> >  
> >  static int pdc_console_tty_write(struct tty_struct *tty, const unsigned char *buf, int count)
> 
> regards,
> -- 
> js
> suse labs
> 
> 
