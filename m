Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab2GXQHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:07:21 -0400
Received: from longford.logfs.org ([213.229.74.203]:48192 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab2GXQHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:07:20 -0400
Date: Tue, 24 Jul 2012 10:53:35 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Steve Hodgson <steve@purestorage.com>
Subject: Re: [PATCH] add blockconsole version 1.1
Message-ID: <20120724145334.GB24954@logfs.org>
References: <20120425132513.GA23492@logfs.org>
 <x49vcknkdvn.fsf@segfault.boston.devel.redhat.com>
 <20120712174633.GA7248@logfs.org>
 <20120713130336.GC10298@x1.osrc.amd.com>
 <20120713162009.GA10268@logfs.org>
 <20120716124614.GA19497@x1.osrc.amd.com>
 <20120718185335.GA1771@logfs.org>
 <20120718214520.GA14067@liondog.tnic>
 <20120723200459.GD17767@logfs.org>
 <20120724154218.GB13753@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120724154218.GB13753@x1.osrc.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 July 2012 17:42:19 +0200, Borislav Petkov wrote:
> 
> Just a minor nuisance: I have this in the log:
> 
> ...
> [   10.498422] console [bcon0] enabled
> [   10.499899] blockconsole: now logging to /dev/sdc at 1
> [   10.594791] usb 5-2: new full-speed USB device number 3 using ohci_hcd
>                                                                                                                                 
> [   12.665911] xhci_hcd 0000:00:10.0: xHCI Host Controller
> [   12.668469] xhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 6
> ...
> 
> which doesn't have the empty line with a bunch of '\s' chars:
> 
> ...
> [   10.498422] console [bcon0] enabled
> [   10.499899] blockconsole: now logging to /dev/sdc at 1
> [   10.594791] usb 5-2: new full-speed USB device number 3 using ohci_hcd
> [   12.665911] xhci_hcd 0000:00:10.0: xHCI Host Controller
> [   12.668469] xhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 6
> ...
> 
> Do you know per-chance why that happens? I have a couple more lines like
> that further in the log file which bcon_tail generated.

If there is no logging for a second, blockconsole will flush the
current sector.  So however much of it is empty will be filled with
spaces and a newline at the end.  Result are those empty lines.

The advantage should be better robustness, in particular when dealing
with cheap flash devices.  Disadvantage is the wasted real estate on
your monitor - although sometimes I have found it nice to have syntax
highlighting (in a way) for pauses in the logging.

Jörn

--
It does not require a majority to prevail, but rather an irate,
tireless minority keen to set brush fires in people's minds.
-- Samuel Adams
