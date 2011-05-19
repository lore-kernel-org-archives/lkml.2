Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab1ESA3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 20:29:31 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43262 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240Ab1ESA3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 20:29:30 -0400
X-Sasl-enc: glrTjXiJQqn1ng+JRIPMoxccyOKGC32hZml5DQsjNaG1 1305764968
Date: Wed, 18 May 2011 17:25:05 -0700
From: Greg KH <greg@kroah.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Jiri Slaby <jslaby@suse.cz>,
        stable@kernel.org, "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [stable] apparent regression (crash) - 2.6.38.6
Message-ID: <20110519002505.GB8697@kroah.com>
References: <4DC9983B.4070006@msgid.tls.msk.ru>
 <4DCA2D14.3040500@suse.cz>
 <1305141557.2606.33.camel@mulgrave.site>
 <20110511193451.GC26010@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511193451.GC26010@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 12:34:51PM -0700, Greg KH wrote:
> On Wed, May 11, 2011 at 02:19:17PM -0500, James Bottomley wrote:
> > On Wed, 2011-05-11 at 08:30 +0200, Jiri Slaby wrote:
> > > On 05/10/2011 09:55 PM, Michael Tokarev wrote:
> > > > Hello.
> > > > 
> > > > I just tried 2.6.38.6 (which has been released today), and
> > > > discovered that it crashes during bootup on my machine.
> > > > 2.6.38.5 with exactly the same config works.
> > > 
> > > Is it reproducible?
> > > 
> > > > Unfortunately I don't have time _right now_ to debug the
> > > > issue, but will try tomorrow.
> > > > 
> > > > For now, here's a part of dmesg with an oops, captured
> > > > using netconsole.  If someone have a clue, please speak
> > > > up ;)
> > > > 
> > > > What I also noticed is that for some reason, udev now loads
> > > > option driver (option: v0.7.2:USB Driver for GSM modems),
> > > > even if I don't have any modems connected to the system.
> > > > This is obviously not related to the issue at hand.
> > > ...
> > > > [  106.761932] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:12.1/usb2/2-2/2-2:1.0/input/input6
> > > > [  106.762170] generic-usb 0003:046D:C044.0004: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:12.1-2/input0
> > > > [  106.994177] scsi 10:0:0:0: Direct-Access     Kingston DT HyperX        HMAP PQ: 0 ANSI: 0 CCS
> > > > [  106.994458] sd 10:0:0:0: Attached scsi generic sg3 type 0
> > > > [  106.994628] BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
> > > > [  106.994755] IP: [<ffffffff811bec1b>] elv_queue_empty+0x1b/0x30
> > 
> > Hmm, it's another missing elevator guard, like this patch:
> > 
> > http://marc.info/?l=linux-scsi&m=130348673628282
> > 
> > I think the bug here is that q->elevator is null, so dereferencing
> > elevator->ops gives the bug.
> 
> Is this patch going to Linus anytime soon?

Ping?

