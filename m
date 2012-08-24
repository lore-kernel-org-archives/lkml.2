Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622Ab2HXRDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 13:03:53 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:52500 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894Ab2HXRDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 13:03:51 -0400
X-Originating-IP: 217.70.178.134
X-Originating-IP: 50.43.46.74
Date: Fri, 24 Aug 2012 10:03:43 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Joe Millenbach <jmillenbach@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        team-fjord@googlegroups.com
Subject: Re: [PATCH] tty: Added a CONFIG_TTY option to allow removal of TTY
Message-ID: <20120824170342.GA9794@jtriplet-mobl1>
References: <1345499431-21658-1-git-send-email-jmillenbach@gmail.com>
 <20120821142047.777e4bb0@pyramind.ukuu.org.uk>
 <CADwDc1AvCvWbj8znN-1WbkZA9WYVAqaTkxi7+ENZfJ-qFNRAvw@mail.gmail.com>
 <CADwDc1BgCM9AA4T3mUxfOGNaNoYwERP-x4y2ZS4mAhfF-K_qzA@mail.gmail.com>
 <20120824141537.63274081@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120824141537.63274081@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 02:15:37PM +0100, Alan Cox wrote:
> On Thu, 23 Aug 2012 18:14:48 -0700
> Joe Millenbach <jmillenbach@gmail.com> wrote:
> > On Tue, Aug 21, 2012 at 6:20 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > >
> > > ...
> > >
> > > >  config MOUSE_PS2
> > > >       tristate "PS/2 mouse"
> > > > +     depends on TTY
> > >
> > > It shouldn't. It would be good to understand why this occurs.
> > 
> > 
> > If I enable this config option, and turn off TTY I get the below errors.
> > 
> > drivers/built-in.o: In function `serport_ldisc_read':
> > serport.c:(.text+0x1aace6): undefined reference to `tty_name'
> > serport.c:(.text+0x1aad57): undefined reference to `tty_name'
> > drivers/built-in.o: In function `serport_init':
> > serport.c:(.init.text+0x8478): undefined reference to `tty_register_ldisc'
> > drivers/built-in.o: In function `serport_exit':
> > serport.c:(.exit.text+0xb29): undefined reference to `tty_unregister_ldisc'
> > 
> > All because MOUSE_PS2 depends on SERIO, just like a lot of entries I
> > blocked.  I assume this means I should keep the dependency on TTY.
> > Unfortunately, I don't have time to dig deeper for the true cause of the
> > dependency right now.
> 
> The true cause I think is that serio/serport.c should depend on tty to be
> built but the ps/2 mouse bits shouldn't.

On the other hand, most people disabling CONFIG_TTY will be building an
extreme embedded system, and on such a system a PS/2 mouse seems highly
unlikely.  Given that, perhaps the goal of removing dependencies on TTY
could happen incrementally once CONFIG_TTY exists?

- Josh Triplett
