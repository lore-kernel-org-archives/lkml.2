Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427Ab2JKVlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 17:41:05 -0400
Received: from foo.stuge.se ([212.116.89.98]:40774 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759399Ab2JKVlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 17:41:02 -0400
Message-ID: <20121011214059.2038.qmail@stuge.se>
Date: Thu, 11 Oct 2012 23:40:59 +0200
From: Peter Stuge <peter@stuge.se>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: REGRESSION: usbdevfs:
	Use-scatter-gather-lists-for-large-bulk-transfers
Mail-Followup-To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20121010203118.GA792@polaris.bitmath.org> <5076819C.9010504@redhat.com> <20121011213707.GA2187@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121011213707.GA2187@polaris.bitmath.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrik Rydberg wrote:
> Hi Hans,
> 
> > Oh what fun (not). The best way to figure out what really is going
> > on is to get some usb level traces. Note my first hunch is that what
> > you're seeing is a device firmware bug, as this patch together with
> > a new libusb (which you seem to also have) will make bulk transfers
> > run slightly faster, which might be just enough to overwhelm your
> > device ...
> 
> Or, the large bulk transfer actually never worked in the first place.
> The list you gave me seemed boringly long, so I read the patch more
> closely instead. The fix below is the result. Greg, will you please
> take it through your tree?
> 
> Thanks,
> Henrik
> 
> From 40b70394747eea51fdd07cc8213dd6afd24b1b30 Mon Sep 17 00:00:00 2001
> From: Henrik Rydberg <rydberg@euromail.se>
> Date: Thu, 11 Oct 2012 23:27:04 +0200
> Subject: [PATCH] usbdevfs: Fix broken scatter-gather transfer
> 
> The recently introduced handling of large bulk transfers is completely
> broken; the same user page is read over and over again. Fixed with
> this patch.
> 
> Cc: stable@kernel.org
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Acked-by: Peter Stuge <peter@stuge.se>
