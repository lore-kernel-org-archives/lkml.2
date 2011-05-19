Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab1ESDjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 23:39:46 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54389 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932497Ab1ESDjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 23:39:45 -0400
Subject: Re: [stable] apparent regression (crash) - 2.6.38.6
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Greg KH <greg@kroah.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Jiri Slaby <jslaby@suse.cz>,
        stable@kernel.org, "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20110519002505.GB8697@kroah.com>
References: <4DC9983B.4070006@msgid.tls.msk.ru> <4DCA2D14.3040500@suse.cz>
	 <1305141557.2606.33.camel@mulgrave.site> <20110511193451.GC26010@kroah.com>
	 <20110519002505.GB8697@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 May 2011 07:39:27 +0400
Message-ID: <1305776367.2576.0.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 17:25 -0700, Greg KH wrote:
> On Wed, May 11, 2011 at 12:34:51PM -0700, Greg KH wrote:
> > On Wed, May 11, 2011 at 02:19:17PM -0500, James Bottomley wrote:
> > > On Wed, 2011-05-11 at 08:30 +0200, Jiri Slaby wrote:
> > > > On 05/10/2011 09:55 PM, Michael Tokarev wrote:
> > > > > Hello.
> > > > > 
> > > > > I just tried 2.6.38.6 (which has been released today), and
> > > > > discovered that it crashes during bootup on my machine.
> > > > > 2.6.38.5 with exactly the same config works.
> > > > 
> > > > Is it reproducible?
> > > > 
> > > > > Unfortunately I don't have time _right now_ to debug the
> > > > > issue, but will try tomorrow.
> > > > > 
> > > > > For now, here's a part of dmesg with an oops, captured
> > > > > using netconsole.  If someone have a clue, please speak
> > > > > up ;)
> > > > > 
> > > > > What I also noticed is that for some reason, udev now loads
> > > > > option driver (option: v0.7.2:USB Driver for GSM modems),
> > > > > even if I don't have any modems connected to the system.
> > > > > This is obviously not related to the issue at hand.
> > > > ...
> > > > > [  106.761932] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:12.1/usb2/2-2/2-2:1.0/input/input6
> > > > > [  106.762170] generic-usb 0003:046D:C044.0004: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:12.1-2/input0
> > > > > [  106.994177] scsi 10:0:0:0: Direct-Access     Kingston DT HyperX        HMAP PQ: 0 ANSI: 0 CCS
> > > > > [  106.994458] sd 10:0:0:0: Attached scsi generic sg3 type 0
> > > > > [  106.994628] BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
> > > > > [  106.994755] IP: [<ffffffff811bec1b>] elv_queue_empty+0x1b/0x30
> > > 
> > > Hmm, it's another missing elevator guard, like this patch:
> > > 
> > > http://marc.info/?l=linux-scsi&m=130348673628282
> > > 
> > > I think the bug here is that q->elevator is null, so dereferencing
> > > elevator->ops gives the bug.
> > 
> > Is this patch going to Linus anytime soon?
> 
> Ping?

I pinged Jens about it yesterday; he said it should be on its way to
Linus.

James


