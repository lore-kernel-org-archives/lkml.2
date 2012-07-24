Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab2GXTGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 15:06:19 -0400
Received: from longford.logfs.org ([213.229.74.203]:41861 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab2GXTGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 15:06:18 -0400
Date: Tue, 24 Jul 2012 13:52:32 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Steve Hodgson <steve@purestorage.com>
Subject: Re: [PATCH] add blockconsole version 1.1
Message-ID: <20120724175232.GC24954@logfs.org>
References: <20120712174633.GA7248@logfs.org>
 <20120713130336.GC10298@x1.osrc.amd.com>
 <20120713162009.GA10268@logfs.org>
 <20120716124614.GA19497@x1.osrc.amd.com>
 <20120718185335.GA1771@logfs.org>
 <20120718214520.GA14067@liondog.tnic>
 <20120723200459.GD17767@logfs.org>
 <20120724154218.GB13753@x1.osrc.amd.com>
 <20120724145334.GB24954@logfs.org>
 <20120724162546.GC13753@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120724162546.GC13753@x1.osrc.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 July 2012 18:25:47 +0200, Borislav Petkov wrote:
> > The advantage should be better robustness, in particular when dealing
> > with cheap flash devices.
> 
> In the sense that we flush the current sector after one second the
> latest so that we can lose as small amount of data as possible if the
> system crashes right at that point?

In the sense that cheap devices don't always handle rewrites of the
same sector well.  Often this results in the entire erase block being
rewritten, causing bad performance and wear-out.  Many cheap devices
aren't real block devices.  They are barely good enough to support
FAT and may die near-instantly with a different write pattern.
Blockconsole assumes utter crap as an underlying device.

The timer mainly ensures that, on a quiet system, those two lines of
output from half an hour ago actually make it to the device
eventually.  In the case of a crash, the panic notifier is supposed to
do the same for those messages you _really_ care about.

> Ok, I see what you mean. I see a red line in vim here. Ok, good to know,
> maybe this feature with the empty lines could be in the docs too so
> people don't ask that question again?

Last paragraph. ;)

> Or you issue a tag instead of an empty line like so:
> 
> [   10.498422] console [bcon0] enabled
> [   10.499899] blockconsole: now logging to /dev/sdc at 1
> [   10.594791] usb 5-2: new full-speed USB device number 3 using ohci_hcd
> <<LOG timeout of 1sec>>
> [   12.665911] xhci_hcd 0000:00:10.0: xHCI Host Controller
> [   12.668469] xhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 6
> 
> which explains everything.

That would only work if you have at least 26 bytes to pad.  Bunch of
spaces with a newline works for any value between 0 and 512.

Jörn

--
Invincibility is in oneself, vulnerability is in the opponent.
-- Sun Tzu
