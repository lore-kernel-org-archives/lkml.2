Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933514Ab2GKXiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 19:38:19 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:39597 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab2GKXiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 19:38:17 -0400
Subject: Re: mmotm 2012-07-10-16-59 uploaded (staging/ccg)
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-next@vger.kernel.org, Mike Lockwood <lockwood@android.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>
In-Reply-To: <20120711151644.23016bd8.akpm@linux-foundation.org>
References: <20120711000148.BAD1E5C0050@hpza9.eem.corp.google.com>
	 <4FFDF7BC.6050602@xenotime.net>
	 <20120711151644.23016bd8.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Jul 2012 16:38:14 -0700
Message-ID: <1342049894.18004.98.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Wed, 2012-07-11 at 15:16 -0700, Andrew Morton wrote:
> On Wed, 11 Jul 2012 15:01:32 -0700
> Randy Dunlap <rdunlap@xenotime.net> wrote:
> 
> > In file included from drivers/staging/ccg/ccg.c:59:0:
> > drivers/staging/ccg/../../usb/gadget/f_fs.c:41:0: warning: "pr_vdebug" redefined
> > drivers/staging/ccg/../../usb/gadget/u_serial.c:138:0: note: this is the location of the previous definition
> 
> <looks at drivers/staging/ccg/ccg.c>
> 
> : /*
> :  * Kbuild is not very cooperative with respect to linking separately
> :  * compiled library objects into one module.  So for now we won't use
> :  * separate compilation ... ensuring init/exit sections work to shrink
> :  * the runtime footprint, and giving us at least some parts of what
> :  * a "gcc --combine ... part1.c part2.c part3.c ... " build would.
> :  */
> : #include "../../usb/gadget/usbstring.c"
> : #include "../../usb/gadget/config.c"
> : #include "../../usb/gadget/epautoconf.c"
> : #include "../../usb/gadget/composite.c"
> : 
> : #include "../../usb/gadget/f_mass_storage.c"
> : #include "../../usb/gadget/u_serial.c"
> : #include "../../usb/gadget/f_acm.c"
> : #define USB_ETH_RNDIS y
> : #include "../../usb/gadget/f_rndis.c"
> : #include "../../usb/gadget/rndis.c"
> : #include "../../usb/gadget/u_ether.c"
> : #include "../../usb/gadget/f_fs.c"
> 
> What nonsense is this?
> 
> Who wrote that rotten comment?  What does "not very cooperative" mean? 
> This alleged lack of cooperation is the central issue, but you couldn't
> be bothered actually describing it?  How the heck is anyone else to
> understand the problem and suggest fixes?  argh.
> 
> It talks about library objects.  Really?  Is there a .a file
> involved here, or is that just a thinko?  If there is indeed a .a file
> then I'm not surprised there are problems: don't do that.  If instead
> we're just talking about a bunch of .o files then I'm rather curious to
> know what "not very cooperative" means.
> 

I certainly won't attempt to defend this particular piece of code, but
FYI the original design limitation(s) for usb-gadget that requires this
type of strangeness was elaborated by Sebastian a few months back here:

http://www.spinics.net/lists/target-devel/msg02374.html

--nab

