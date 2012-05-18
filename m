Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759027Ab2ERSGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 14:06:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54408 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab2ERSGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 14:06:33 -0400
Date: Fri, 18 May 2012 11:06:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Rabin Vincent <rabin@rab.in>, alan@linux.intel.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Race in vt_event_wait() during suspend/resume
Message-ID: <20120518180628.GA27021@kroah.com>
References: <CAH+eYFAm-bp5nRgK4mBJa4CSoXw3V4wNvCUbnB+A8Ywvs3=M1w@mail.gmail.com>
 <20120518124051.6cd03ab0@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518124051.6cd03ab0@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 12:40:51PM +0100, Alan Cox wrote:
> On Fri, 18 May 2012 16:34:53 +0530
> Rabin Vincent <rabin@rab.in> wrote:
> 
> > pm_restore_console() is called from the suspend/resume path,
> > this calls vt_move_to_console(), which calls vt_event_wait().
> > 
> > There's a race in this path which causes the process
> > which requests the suspend to sleep indefinitely waiting
> > for an event which already happened:
> > 
> > P1					P2
> >  vt_move_to_console()
> >    set_console()
> >      schedule_console_callback()
> >    vt_waitactive()
> >      check n == fg_console +1
> > 					console_callback()
> > 					  switch_screen()
> > 					  vt_event_post() // no waiters
> > 
> >      vt_event_wait() // forever
> > 
> > I think the following should fix it.  Comments?
> > 
> 
> Looks right to me.

Great, Rabin, care to resend it with a proper Signed-off-by: line so
that I can apply it?

thanks,

greg k-h
