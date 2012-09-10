Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab2IJRSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:18:06 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:32950 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab2IJRSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:18:04 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 10 Sep 2012 19:17:39 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: shuah.khan@hp.com
Cc: Clemens Ladisch <clemens@ladisch.de>, LKML <linux-kernel@vger.kernel.org>,
        linux1394-devel@lists.sf.net, shuahkhan@gmail.com
Subject: Re: [RFC] DMA mapping error check analysis
Message-ID: <20120910191739.77d59f65@stein>
In-Reply-To: <1347290775.3071.1.camel@lorien2>
References: <1346595257.4377.5.camel@lorien2>
	<1347033200.2603.19.camel@lorien2>
	<504D9C70.5000102@ladisch.de>
	<1347290775.3071.1.camel@lorien2>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 10 Shuah Khan wrote:
> 
> > >
> > > http://linuxdriverproject.org/mediawiki/index.php/DMA_Mapping_Error_Analysis
> > 
> > > File Name                  # of calls  Status 	
> > > drivers/firewire/core-iso.c   1        Unmap Broken
> > > drivers/firewire/ohci.c       1        Unmap Broken
> > 
> > In ohci.c, ar_context_release() takes care of cleanup.
> > 
> > In core-iso.c, on failure, the callers are responsible to call
> > fw_iso_buffer_destroy() eventually.  (ioctl_create_iso_context()
> > doesn't do this correctly if it's called multiple times.)
> > 
> 
> Thanks. I updated the page with your comments. I moved ohci.c to Good
> status and left core-iso.c in Unmap Broken in case
> ioctl_create_iso_context() case is worth fixing.

I don't see what could go wrong if ioctl_create_iso_context() is called
multiple times.  But I wrote the current (= v3.5-rc1) serialization code in
it, hence am blind for mistakes which are my own.  So anyboy who spots an
actual problem please describe it, or even better send a patch.

(Hmm, fw_device_op_mmap()'s fail: path is executed outside the
client->lock protected section.  That might be a problem.  I need to look
further into it.)
-- 
Stefan Richter
-=====-===-- =--= -=-=-
http://arcgraph.de/sr/
