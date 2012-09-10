Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab2IJP0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 11:26:23 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:13299 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab2IJP0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 11:26:18 -0400
Message-ID: <1347290775.3071.1.camel@lorien2>
Subject: Re: [RFC] DMA mapping error check analysis
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Clemens Ladisch <clemens@ladisch.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux1394-devel@lists.sf.net,
        shuahkhan@gmail.com
Date: Mon, 10 Sep 2012 09:26:15 -0600
In-Reply-To: <504D9C70.5000102@ladisch.de>
References: <1346595257.4377.5.camel@lorien2>
	 <1347033200.2603.19.camel@lorien2> <504D9C70.5000102@ladisch.de>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >
> > http://linuxdriverproject.org/mediawiki/index.php/DMA_Mapping_Error_Analysis
> 
> > File Name                  # of calls  Status 	
> > drivers/firewire/core-iso.c   1        Unmap Broken
> > drivers/firewire/ohci.c       1        Unmap Broken
> 
> In ohci.c, ar_context_release() takes care of cleanup.
> 
> In core-iso.c, on failure, the callers are responsible to call
> fw_iso_buffer_destroy() eventually.  (ioctl_create_iso_context()
> doesn't do this correctly if it's called multiple times.)
> 

Thanks. I updated the page with your comments. I moved ohci.c to Good
status and left core-iso.c in Unmap Broken in case
ioctl_create_iso_context() case is worth fixing.

-- Shuah

