Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab0KLEWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 23:22:49 -0500
Received: from static-220-247-10-204.b-man.svips.gol.ne.jp ([220.247.10.204]:42693
	"EHLO smtp.kamineko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab0KLEWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 23:22:47 -0500
Date: Fri, 12 Nov 2010 13:22:43 +0900
From: Mattia Dongili <malattia@linux.it>
To: Norbert Preining <preining@logic.at>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: regression since 2.6.36: backlight in sony-laptop not working
Message-ID: <20101112042243.GE2852@kamineko.org>
References: <20101104142915.GC7650@gamma.logic.tuwien.ac.at>
 <20101110035833.GB3029@kamineko.org>
 <20101111235000.GA6651@gamma.logic.tuwien.ac.at>
 <20101112034423.GA7407@srcf.ucam.org>
 <20101112035027.GD26742@gamma.logic.tuwien.ac.at>
 <20101112035732.GB7574@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101112035732.GB7574@srcf.ucam.org>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.35+ x86_64
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 03:57:32AM +0000, Matthew Garrett wrote:
> On Fri, Nov 12, 2010 at 12:50:27PM +0900, Norbert Preining wrote:
> > THen the problem is simply that the acpi events are not coming through
> > when pressing the respective keys.
> 
> Then yes, that's probably related to sony-laptop. If you run evtest 
> against the /dev/input/event device that corresponds to sony-laptop, 
> what events do you get when you hit the brightness keys?

backlight (actually Fn+F[56]) is one of those keys the needs remapping
these days, i.e. if xev doesn't get any event in X then you may need
something like:

$ diff -u <(sudo input-kbd 5) vaio-kbd
/dev/input/event5
   bustype : BUS_ISA
   vendor  : 0x104d
   product : 0x0
   version : 0
   name    : "Sony Vaio Keys"
   bits ev : EV_SYN EV_KEY EV_MSC

map: 44 keys, size: 59/64
--- /proc/self/fd/11    2010-11-12 13:10:39.811178332 +0900
+++ vaio-kbd    2010-10-31 19:24:49.000000000 +0900
@@ -4,8 +4,8 @@
 0x0006 = 467  # KEY_FN_F2
 0x0007 = 468  # KEY_FN_F3
 0x0008 = 469  # KEY_FN_F4
-0x0009 = 470  # KEY_FN_F5
-0x000a = 471  # KEY_FN_F6
+0x0009 = 224  # KEY_BRIGHTNESSDOWN
+0x000a = 225  # KEY_BRIGHTNESSUP
 0x000b = 472  # KEY_FN_F7
 0x000c = 473  # KEY_FN_F8
 0x000d = 474  # KEY_FN_F9

See the manpage for input-kbd and /usr/include/linux/input.h for valid
key values.
In short `input-kbd <devNo>` gives you the current map. Redirect the
output to a file, edit it to change the keys you need remapped and run
`input-kbd -f <file> <devNo>`.

For a reference look at this bug report:
http://bugs.freedesktop.org/show_bug.cgi?id=11227

If the above is not the case then there might be another problem in
sony-laptop as Matthew suggests.
-- 
mattia
:wq!
