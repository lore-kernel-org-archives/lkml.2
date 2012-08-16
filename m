Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054Ab2HPQbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:31:10 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:43674 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932942Ab2HPQbH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:31:07 -0400
Date: Thu, 16 Aug 2012 18:30:21 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 0/7] HID: picoLCD updates
Message-ID: <20120816183021.68c37f37@neptune.home>
In-Reply-To: <alpine.LNX.2.00.1208152329580.7026@pobox.suse.cz>
References: <20120730213656.0a9f6d30@neptune.home>
	<alpine.LNX.2.00.1208151016221.7026@pobox.suse.cz>
	<20120815114236.0f7db40e@neptune.home>
	<alpine.LNX.2.00.1208151409500.7026@pobox.suse.cz>
	<20120815171635.2564a4a8@neptune.home>
	<alpine.LNX.2.00.1208152329580.7026@pobox.suse.cz>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 August 2012 Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 15 Aug 2012, Bruno Prémont wrote:
> > > I see. Alan Stern has fixed a huge pile of things in this area in 3.6-rc1. 
> > > I have expected all of those to actually be on theoretical problems not 
> > > ever having happened in the wild, but it might be that you are actually 
> > > chasing on of those.
> > >
> > > Could you please retest with latest Linus' tree (or at least eb055fd0560b) 
> > > to see whether this hasn't actually been fixed already by Alan's series?
> > 
> > I've started trying that out, it seems Alan's work improved things.
> > 
> > For the first few attempts I have not seen SLAB corruptions, though after
> > a few rounds I hit accumulation of the following messages:
> > [  297.174828] hid-picolcd 0003:04D8:C002.0003: output queue full
> > [  297.181098] hid-picolcd 0003:04D8:C002.0003: output queue full
> > [  297.187820] hid-picolcd 0003:04D8:C002.0003: output queue full
> > [  297.194087] hid-picolcd 0003:04D8:C002.0003: output queue full
> > 
> > with sporadically in between:
> > [  292.668019] hid-picolcd 0003:04D8:C002.0003: usb_submit_urb(out) failed: -1
> > 
> > At first glance I think the queue filling up and never draining is caused
> > by hid_hw_stop() stalling the queue and the time between both being just too
> > short.
> 
> I don't really understand this explanation. Once usb_kill_urb() returns, 
> the URB should be available for future use (and therefore all queues 
> completely drained).

I won't have time today to check, though my guess is that on each
echo $usb-id > bind; echo $usb-id > unbind
under /sys/bus/hid/drivers/hid-picolcd/ the USB urb queue fills a bit does
not get cleared.

Is usb_kill_urb() called when unbinding just the specific hid driver? If so
my short timing between bind/unbind must be triggering something else...

Otherwise I'm missing something as at first time I got no "output queue full"
messages, but as I repeated the bind/unbind sequences the prints per bind/unbind
iteration increased in number.

Anyhow, on Friday evening/week-end I will continue digging and report back with my
findings.

Thanks,
Bruno
