Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab1IKQv2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 12:51:28 -0400
Received: from mx.treblig.org ([80.68.94.177]:34885 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329Ab1IKQv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 12:51:28 -0400
Date: Sun, 11 Sep 2011 17:51:26 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: "Fr?d?ric L. W. Meunier" <fredlwm@fredlwm.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Floppy: drive, floppy or driver problem ?
Message-ID: <20110911165126.GA26442@gallifrey>
References: <20110911025509.GB18956@pervalidus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110911025509.GB18956@pervalidus>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.36.4-kvm-i386-20110819 (i686)
X-Uptime: 17:43:59 up 16 days, 16:46,  1 user,  load average: 0.00, 0.01,
 0.05
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Fr?d?ric L. W. Meunier (fredlwm@fredlwm.net) wrote:
> I tried 'dd if=/dev/fd0 of=foo.img' on a few floppy drives, and the first 
> returned
> 
> Sep 10 21:53:58 pervalidus kernel: ------------[ cut here ]------------
> Sep 10 21:53:58 pervalidus kernel: WARNING: at /usr/local/src/kernel/linux-3.0/drivers/block/floppy.c:1041 setup_rw_floppy+0x1ab/0x276 [floppy]()
> Sep 10 21:53:58 pervalidus kernel: Hardware name: GA-MA69VM-S2
> Sep 10 21:53:58 pervalidus kernel: floppy_disable_hlt() scheduled for removal in 2012

OK, well that's a kernel warning; doesn't look like too much to be worried about.

> Sep 10 21:54:09 pervalidus kernel: floppy0: data CRC error: track 18, head 1, sector 14, size 2
> Sep 10 21:54:10 pervalidus kernel: floppy0: data CRC error: track 18, head 1, sector 14, size 2
> Sep 10 21:54:10 pervalidus kernel: end_request: I/O error, dev fd0, sector 679
> Sep 10 21:54:10 pervalidus kernel: Buffer I/O error on device fd0, logical block 84

Well that looks like a bad sector read - either the drive or the floppy; if
you're getting the same values in multiple drives then probably the floppy.
I'm not convinced any 1.44MB floppies manage to survive more than 1 or 2
reads (if you're lucky....).   So from that error you're at head 1 on cylinder
18, and with 18 sectors/track we get to sector 666 (!!) + 14 -> 680 - which
is close enough to the 679 reported for me think that's about right.
Not quite sure where the 84 comes from - 4KB blocks?

Anyway, sounds like duff disk.

> With the others, some didn't return any error, while others returned the 
> same errors from the last four lines.
> 
> But I then retried with the first floppy, and it didn't return anything in 
> two runs.
> 
> Anyway, looking in my logs, I also got it once in the past:
> 
> Aug 25 19:29:51 pervalidus kernel: ------------[ cut here ]------------
> Aug 25 19:29:51 pervalidus kernel: WARNING: at /usr/local/src/kernel/linux-3.0/drivers/block/floppy.c:1041 setup_rw_floppy+0x1ab/0x276 [floppy]()
> Aug 25 19:29:51 pervalidus kernel: Hardware name: GA-MA69VM-S2
> Aug 25 19:29:51 pervalidus kernel: floppy_disable_hlt() scheduled for removal in 2012

Same warning as above.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
