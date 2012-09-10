Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369Ab2IJT20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 15:28:26 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40409 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758337Ab2IJT2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 15:28:25 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 10 Sep 2012 21:28:04 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: shuah.khan@hp.com, LKML <linux-kernel@vger.kernel.org>,
        linux1394-devel@lists.sf.net, shuahkhan@gmail.com
Subject: Re: [RFC] DMA mapping error check analysis
Message-ID: <20120910212804.30342e41@stein>
In-Reply-To: <504E267A.8060307@ladisch.de>
References: <1346595257.4377.5.camel@lorien2>
	<1347033200.2603.19.camel@lorien2>
	<504D9C70.5000102@ladisch.de>
	<1347290775.3071.1.camel@lorien2>
	<20120910191739.77d59f65@stein>
	<504E267A.8060307@ladisch.de>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 10 Clemens Ladisch wrote:
> fw_iso_buffer_map_dma() maps as many pages as it can, and saves in
> ->page_count_mapped how many pages need unmapping.
> 
> When fw_iso_buffer_map_dma() fails, ioctl_create_iso_context() does _not_
> call fw_iso_buffer_destroy() but takes care to not change the cdev's
> state in any other way.  So ioctl_create_iso_context() can be called
> again and will then call fw_iso_buffer_map_dma(), which will happily
> map the pages a second time, overwriting the previous mapped addresses.

Indeed; thank you.  I make a note to fix this when I get some time.
-- 
Stefan Richter
-=====-===-- =--= -=-=-
http://arcgraph.de/sr/
