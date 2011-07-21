Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab1GUMI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 08:08:28 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21425 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab1GUMIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 08:08:25 -0400
Date: Thu, 21 Jul 2011 14:08:23 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Michael Krufky <mkrufky@kernellabs.com>
cc: linux-media@vger.kernel.org, Mike Isely <isely@pobox.com>,
        Aurelien Alleaume <slts@free.fr>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: Hauppauge model 73219 rev D1F5 tuner doesn't detect signal,
 older rev D1E9 works
In-Reply-To: <CAOcJUbz9ZeUHOzkgVfktwJ4vH9+HOP3=EfVP2xbaYhB49Gcbug@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1107211403290.30225@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107151455140.28453@swampdragon.chaosbits.net> <CAOcJUbz9ZeUHOzkgVfktwJ4vH9+HOP3=EfVP2xbaYhB49Gcbug@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jul 2011, Michael Krufky wrote:

> On Tue, Jul 19, 2011 at 3:37 AM, Jesper Juhl <jj@chaosbits.net> wrote:
> > Hi
> >
> > I have a bunch of Hauppauge HVR-1900 model 73219's, some are revision D1E9
> > and work perfectly, but with the newer revision D1F5's the tuner fails to
> > detect a signal and consequently just gives me blank output on
> > /dev/video0. Other input sources, like composite or s-video, work just
> > fine on the new revision, it's just the tuner that does not work.
> >
...
> >
> > If I now do 'cat /dev/video0 > test.mpg' I get a perfectly valid MPEG
> > stream, but a rather boring one - just a black display and no audio.
> >
> > With the old D1E9 revision I get
> >
> > [root@dragon ~]# cat /sys/class/pvrusb2/sn-6569758/ctl_signal_present/cur_val
> > 65535
> > [root@dragon ~]#
> >
> > and 'cat /dev/video0 > test.mpg' gives me the stream I'd expect (as in
> > actual contents, not just a black screen).
> >
> > Any ideas on how to fix this?
> >
> > I can test any patches you may come up with and if there's any further
> > information you need from me in order to get an idea about what the
> > problem is, then just ask.
> >
> > Please CC me on replies since I'm not subscribed to the linux-media list.
> >

Ok, so things did change a bit :-)

I still get a 0 when I cat ctl_signal_present/cur_val , but I no longer 
get just a black stream from the bideo device now I get static and very 
badly tuned "images".  See for example: 
http://personal.chaosbits.net/hauppauge-pvr-1900-test.mpg which is the 
result of 
  cat /dev/video1 > /tmp/hauppauge-pvr-1900-test.mpg & seq 147250280 147250310 | while read i; do echo $i > /sys/class/pvrusb2/sn-6569758/ctl_frequency/cur_val; sleep 2; done ; killall cat

  (warning - large file - ~65MB)

Definately an improvement.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

