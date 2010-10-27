Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab0J0J1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 05:27:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:33010 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab0J0J1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 05:27:47 -0400
Date: Wed, 27 Oct 2010 11:27:44 +0200
From: "Dr. Werner Fink" <werner@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jiri Slaby <jslaby@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 28/49] tty: Add a new file /proc/tty/consoles
Message-ID: <20101027092744.GA27071@boole.suse.de>
Mail-Followup-To: Al Viro <viro@ZenIV.linux.org.uk>,
	Jiri Slaby <jslaby@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
	linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20101022175112.GC13489@kroah.com>
 <1287771688-14805-28-git-send-email-gregkh@suse.de>
 <4CC2C9A8.1040003@suse.cz>
 <20101025075125.GA29179@boole.suse.de>
 <20101027005045.GC19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101027005045.GC19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 01:50:45AM +0100, Al Viro wrote:
> On Mon, Oct 25, 2010 at 09:51:25AM +0200, Dr. Werner Fink wrote:
> > > Maybe I wouldn't bother with marking the "current" console by star at
> > > all as it seems not to pay off.
> > 
> > This is the main reason for what I've done this patch:
> > To see on which console line the reading process is
> > located. Please do not skip this part as this is
> > currently the only way to detect the real console below
> > /dev/console ... it could be used in user space: e.g. in
> > plymouth or bootlogd (to deterime the main console) or
> > sulogin (to be able to provide a prompt on all console
> > lines).
> 
> You've got to be kidding.  So all this stuff is about getting TIOCGDEV
> into the mainline?  In a form that would, presumably, be more acceptable
> than an ioctl?

What is kidding about this user space problem?  Currently
there is no way to detect the terminal lines used for the
system console.  Running on /dev/console an application
has to steal the controlling tty to detect the preferred
terminal line of the system console (and only the preferred
line).  Last week the author of systemd had asked me why
the TIOCGDEV patch was not send upstream.  I've told him
that this was done but that several patches were never
accepted upstream, compare with:

http://lkml.org/lkml/2000/12/15/160

and the follow ups there. Even more the author of the old
SysVinit had run into the same problem:

http://lkml.org/lkml/1998/3/21/57

It seems to me that the list of the terminal devices of
the system consoles are useful in user space as Randy
Dunlap tolds me here

http://article.gmane.org/gmane.linux.kernel.api/1653

Such a list would be very helpful e.g. to extend sulogin
to be able to prompt for maintenance on all terminal lines
of the system console after e.g. failed fsck.  Currently
only the preferred terminal line is prompted for maintenance.

> > -- 
> >   "Having a smoking section in a restaurant is like having
> >           a peeing section in a swimming pool." -- Edward Burr
> 
> Ironic, innit?

depends on ;)

Werner

-- 
System V style init programs - http://savannah.nongnu.org/projects/sysvinit/
