Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762217Ab2KBREO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:04:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760792Ab2KBREL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:04:11 -0400
Date: Fri, 2 Nov 2012 13:03:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Chris Friesen <chris.friesen@genband.com>
Cc: Pavel Machek <pavel@ucw.cz>, Eric Paris <eparis@parisplace.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121102170349.GJ3300@redhat.com>
References: <1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
 <1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
 <1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
 <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
 <20121101202701.GB20817@xo-6d-61-c0.localdomain>
 <5092E361.7080901@genband.com>
 <20121102154833.GG3300@redhat.com>
 <5093FADA.2040004@genband.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5093FADA.2040004@genband.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 10:54:50AM -0600, Chris Friesen wrote:
> On 11/02/2012 09:48 AM, Vivek Goyal wrote:
> >On Thu, Nov 01, 2012 at 03:02:25PM -0600, Chris Friesen wrote:
> 
> >>With secure boot enabled, then the kernel should refuse to let an
> >>unsigned kexec load new images, and kexec itself should refuse to
> >>load unsigned images.
> >
> >Yep, good in theory. Now that basically means reimplementing kexec-tools
> >in kernel.
> 
> Maybe I'm missing something, but couldn't the vendors provide a
> signed kexec?  Why does extra stuff need to be pushed into the
> kernel?

Bingo. Join us in following mail thread for all the gory details and
extra work required to make signing of user space processes work.

https://lkml.org/lkml/2012/10/24/451

In a nut-shell, there is no infrastructure currently for signing user
space processes and verifying it (like module signing). Then if you
just sign select user processes and not whole of the user space, then
it brings extra complications with linking shared objects and being
able to modify the code of process etc.

So yes, being able to sign /sbin/kexec will be great. Looks like that
itself will require lot of work and is not that straight forward.

Thanks
Vivek
