Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab2GXQZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:25:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51877 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797Ab2GXQZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:25:49 -0400
Date: Tue, 24 Jul 2012 18:25:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Steve Hodgson <steve@purestorage.com>
Subject: Re: [PATCH] add blockconsole version 1.1
Message-ID: <20120724162546.GC13753@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	=?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
	Steve Hodgson <steve@purestorage.com>
References: <x49vcknkdvn.fsf@segfault.boston.devel.redhat.com>
 <20120712174633.GA7248@logfs.org>
 <20120713130336.GC10298@x1.osrc.amd.com>
 <20120713162009.GA10268@logfs.org>
 <20120716124614.GA19497@x1.osrc.amd.com>
 <20120718185335.GA1771@logfs.org>
 <20120718214520.GA14067@liondog.tnic>
 <20120723200459.GD17767@logfs.org>
 <20120724154218.GB13753@x1.osrc.amd.com>
 <20120724145334.GB24954@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120724145334.GB24954@logfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 10:53:35AM -0400, Jörn Engel wrote:
> On Tue, 24 July 2012 17:42:19 +0200, Borislav Petkov wrote:
> > 
> > Just a minor nuisance: I have this in the log:
> > 
> > ...
> > [   10.498422] console [bcon0] enabled
> > [   10.499899] blockconsole: now logging to /dev/sdc at 1
> > [   10.594791] usb 5-2: new full-speed USB device number 3 using ohci_hcd
> >                                                                                                                                 
> > [   12.665911] xhci_hcd 0000:00:10.0: xHCI Host Controller
> > [   12.668469] xhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 6
> > ...
> > 
> > which doesn't have the empty line with a bunch of '\s' chars:
> > 
> > ...
> > [   10.498422] console [bcon0] enabled
> > [   10.499899] blockconsole: now logging to /dev/sdc at 1
> > [   10.594791] usb 5-2: new full-speed USB device number 3 using ohci_hcd
> > [   12.665911] xhci_hcd 0000:00:10.0: xHCI Host Controller
> > [   12.668469] xhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 6
> > ...
> > 
> > Do you know per-chance why that happens? I have a couple more lines like
> > that further in the log file which bcon_tail generated.
> 
> If there is no logging for a second, blockconsole will flush the
> current sector.  So however much of it is empty will be filled with
> spaces and a newline at the end.  Result are those empty lines.

... and this is consistent with the printk timestamps above: 10.5 to
12.6 seconds = one empty line.

> The advantage should be better robustness, in particular when dealing
> with cheap flash devices.

In the sense that we flush the current sector after one second the
latest so that we can lose as small amount of data as possible if the
system crashes right at that point?

And, at the same time, writes to cheap devices get flushed for sure?

> Disadvantage is the wasted real estate on your monitor - although
> sometimes I have found it nice to have syntax highlighting (in a way)
> for pauses in the logging.

Ok, I see what you mean. I see a red line in vim here. Ok, good to know,
maybe this feature with the empty lines could be in the docs too so
people don't ask that question again?

Or you issue a tag instead of an empty line like so:

[   10.498422] console [bcon0] enabled
[   10.499899] blockconsole: now logging to /dev/sdc at 1
[   10.594791] usb 5-2: new full-speed USB device number 3 using ohci_hcd
<<LOG timeout of 1sec>>
[   12.665911] xhci_hcd 0000:00:10.0: xHCI Host Controller
[   12.668469] xhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 6

which explains everything.

Thanks.

-- 
Regards/Gruss,
Boris.
