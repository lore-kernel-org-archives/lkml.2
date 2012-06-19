Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab2FSOVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 10:21:15 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55604 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279Ab2FSOVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 10:21:13 -0400
Date: Tue, 19 Jun 2012 16:21:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: Bojan Smojver <bojan@rexursive.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
Message-ID: <20120619142111.GA4151@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Bojan Smojver <bojan@rexursive.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Alan Stern <stern@rowland.harvard.edu>,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	Linux PM list <linux-pm@vger.kernel.org>,
	Kernel development list <linux-kernel@vger.kernel.org>
References: <90304ca8-31ef-4919-bf9d-e0498b0de87b@email.android.com>
 <201206182229.32055.rjw@sisk.pl>
 <8c993882-5949-471d-a15c-0c91d3d2deb9@email.android.com>
 <201206182328.19811.rjw@sisk.pl>
 <1340071797.1666.24.camel@shrek.rexursive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1340071797.1666.24.camel@shrek.rexursive.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 12:09:57PM +1000, Bojan Smojver wrote:
> On Mon, 2012-06-18 at 23:28 +0200, Rafael J. Wysocki wrote:
> > I think I'd prefer a full status line every 10%.  Or even maybe every
> > 20%.
> 
> Here is one that does a line every 10%:

Yep, here's the output:

[  168.703731] PM: thaw of devices complete after 1474.836 msecs
[  168.713213] PM: Using 1 thread(s) for compression.
[  168.713213] PM: Compressing and saving image data (75028 pages)...
[  168.713497] PM: Saved   0%...
[  169.440467] PM: Saved  10%...
[  169.775404] PM: Saved  20%...
[  170.143273] PM: Saved  30%...
[  170.677134] PM: Saved  40%...
[  171.430144] PM: Saved  50%...
[  172.279117] PM: Saved  60%...
[  173.046114] PM: Saved  70%...
[  173.581322] PM: Saved  80%...
[  174.088198] PM: Saved  90%...
[  174.584271] PM: Saved 100%...
[  174.612895] PM: Saving image done.
		^^^^^^^^^^^ This one is probably not needed - we say 100% in the line above.

[  174.614692] PM: Wrote 300112 kbytes in 5.90 seconds (50.86 MB/s)

And then the "Saved %d%%... " could probably issue on a single line using
KERN_CONT (or what was it now with the new printk changes?):

PM: Saving image: 10%... 20%... 30%... ... 100%.
PM: Wrote 300112 kbytes in 5.90 seconds (50.86 MB/s)

which, on the whole, is nice and compact and still contains the whole
info.

Thanks.

-- 
Regards/Gruss,
Boris.
