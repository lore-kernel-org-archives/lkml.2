Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab1BWAg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 19:36:27 -0500
Received: from tango.0pointer.de ([85.214.72.216]:52383 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab1BWAg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 19:36:26 -0500
Date: Wed, 23 Feb 2011 01:35:55 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] tty: add TIOCVHANGUP: time for revoke() in f_ops ?
Message-ID: <20110223003555.GC21518@tango.0pointer.de>
References: <1297964368.2165.1.camel@yio>
 <20110218095048.4e9f1e1a@lxorguk.ukuu.org.uk>
 <20110222231536.GA18066@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222231536.GA18066@kroah.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22.02.11 15:15, Greg KH (greg@kroah.com) wrote:

> 
> On Fri, Feb 18, 2011 at 09:50:48AM +0000, Alan Cox wrote:
> > > Without this ioctl it would have to temporarily become the owner of
> > > the tty, then call vhangup() and then give it up again.
> > 
> > This is a hack - it's also unfortunately not actually sufficient or
> > complete which is why we didn't do it years ago. Sorry but if it was easy
> > it would have been in a long time back !
> > 
> > 
> > > +	case TIOCVHANGUP:
> > > +		if (!capable(CAP_SYS_ADMIN))
> > 
> > Is there any reason for not allowing revocation of a tty that you are
> > the owner of (ie one you could anyway take ownership of and hangup ?)
> 
> You could do that already today with the vhangup() syscall, right?

BTW, the reason why this isn't allowed is probably that you really don't
want to allow unprivileged folks to kick privileged users of a
TTY. TTYs can be opened by multiple parties, and stuff such as
/dev/ttyS0 might be used by user logins as well as for logging, and you
don't want to allow users to kick off all loggers just like that.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
