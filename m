Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132Ab0KRLEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 06:04:49 -0500
Received: from static-220-247-10-204.b-man.svips.gol.ne.jp ([220.247.10.204]:52226
	"EHLO smtp.kamineko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab0KRLEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 06:04:47 -0500
Date: Thu, 18 Nov 2010 20:04:45 +0900
From: Mattia Dongili <malattia@linux.it>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Norbert Preining <preining@logic.at>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: regression since 2.6.36: backlight in sony-laptop not working
Message-ID: <20101118110445.GB4107@kamineko.org>
References: <20101104142915.GC7650@gamma.logic.tuwien.ac.at>
 <20101110035833.GB3029@kamineko.org>
 <20101111235000.GA6651@gamma.logic.tuwien.ac.at>
 <20101112034423.GA7407@srcf.ucam.org>
 <20101112035027.GD26742@gamma.logic.tuwien.ac.at>
 <20101112035732.GB7574@srcf.ucam.org>
 <20101112042243.GE2852@kamineko.org>
 <20101117063006.GF29129@gamma.logic.tuwien.ac.at>
 <20101117063338.GG29129@gamma.logic.tuwien.ac.at>
 <20101117065252.GA7046@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117065252.GA7046@core.coreip.homeip.net>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.37-rc2+ x86_64
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 10:52:52PM -0800, Dmitry Torokhov wrote:
> On Wed, Nov 17, 2010 at 03:33:38PM +0900, Norbert Preining wrote:
> > > - recompiled a input-kbd binary with a relaxed version check
> > > 	-	if (EV_VERSION != version) {
> > > 	+	if (EV_VERSION > version) {
> > >   in input.c, line 104 of input-utils.
> > 
> > Furthermore, although both of you referred to the fact that udev keymap
> > is working, I checked that Debian/sid uses udev kbd rules, but it 
> > stopped working ...
> > 
> 
> Seems to be working here (I also verified that the keycodces are
> actually emitted with evtest):
> 
> [root@dtor-d630 ~]# /lib/udev/keymap /dev/input/event3 0x87 wlan
> setting scancode 0x87 to key code 238
> [root@dtor-d630 ~]# /lib/udev/keymap /dev/input/event3 0x87 battery
> setting scancode 0x87 to key code 236
> [root@dtor-d630 ~]# uname -r
> 2.6.37-rc1+
> [root@dtor-d630 ~]# 

ok I got the error. I'll see why the EVIOCSKEYCODE syscall is returning
-EINVAL.

-- 
mattia
:wq!
