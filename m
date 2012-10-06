Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab2JFInR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 04:43:17 -0400
Received: from 1wt.eu ([62.212.114.60]:35988 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314Ab2JFInL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 04:43:11 -0400
Date: Sat, 6 Oct 2012 10:42:58 +0200
From: Willy Tarreau <w@1wt.eu>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@gmail.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org
Subject: Re: 3.5 regression on i915
Message-ID: <20121006084258.GB22618@1wt.eu>
References: <20121005234218.GC21163@1wt.eu> <CAPM=9txTo4agvvFnY8KbF82WoCxh0Pmb1HcoEP4ZUbauL5Ws8Q@mail.gmail.com> <20121005235845.GE21163@1wt.eu> <20121006072704.GA22465@1wt.eu> <CAPM=9twQb7BUe6cAD-5THBBP-eYAU56__V5UXNn2qfqdFkVwmA@mail.gmail.com> <20121006075956.GF21163@1wt.eu> <051c15$4i14fm@AZSMGA002.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <051c15$4i14fm@AZSMGA002.ch.intel.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2012 at 09:24:35AM +0100, Chris Wilson wrote:
> More likely X is segfaulting for another reason altogether. Can you
> please attach the stacktrace (with symbols!) and see if another
> bisection is required?

Yes, here it is.

_XSERVTransSocketOpenCOTSServer: Unable to open socket for inet6
_XSERVTransOpen: transport open failed for inet6/eeepc:0
_XSERVTransMakeAllCOTSServerListeners: failed to open listener for inet6

X.Org X Server 1.4.2
Release Date: 11 June 2008
X Protocol Version 11, Revision 0
Build Operating System: Slackware 12.1 Slackware Linux Project
Current Operating System: Linux eeepc 3.5.6-rc1+ #4 SMP Sat Oct 6 10:13:58 CEST 2012 i686
Build Date: 30 June 2008  11:35:29PM
 
        Before reporting problems, check http://wiki.x.org
        to make sure that you have the latest version.
Module Loader present
Markers: (--) probed, (**) from config file, (==) default setting,
        (++) from command line, (!!) notice, (II) informational,
        (WW) warning, (EE) error, (NI) not implemented, (??) unknown.
(==) Log file: "/var/log/Xorg.0.log", Time: Sat Oct  6 10:42:43 2012
(==) Using config file: "/etc/X11/xorg.conf"
(II) Module "ramdac" already built-in
(II) Module "ddc" already built-in
(II) Module "i2c" already built-in
(EE) intel(0): Failed to initialize kernel memory manager

Backtrace:
0: X(xf86SigHandler+0x7e) [0x80d8b5e]
1: [0xffffe400]
2: /usr/lib/xorg/modules/drivers//intel_drv.so(i830_allocator_init+0x332) [0xb73756e2]
3: /usr/lib/xorg/modules/drivers//intel_drv.so [0xb736de51]
4: X(AddScreen+0x1fc) [0x806d42c]
5: X(InitOutput+0x21e) [0x80a1b7e]
6: X(main+0x296) [0x806dbb6]
7: /lib/libc.so.6(__libc_start_main+0xe0) [0xb7581390]
8: X(FontFileCompleteXLFD+0x20d) [0x806d121]

Fatal server error:
Caught signal 11.  Server aborting

giving up.
xinit:  Connection reset by peer (errno 104):  unable to connect to X server
xinit:  No such process (errno 3):  Server error.

Willy

