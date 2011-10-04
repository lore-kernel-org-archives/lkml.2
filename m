Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961Ab1JDRFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 13:05:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932791Ab1JDRFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 13:05:51 -0400
Date: Tue, 4 Oct 2011 10:04:15 -0700
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: Hyper-V TODO file
Message-ID: <20111004170415.GA1320@suse.de>
References: <1316708240-25048-1-git-send-email-kys@microsoft.com>
 <20110922170450.GA4490@suse.de>
 <6E21E5352C11B742B20C142EB499E048081E935D@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110922173618.GA5624@suse.de>
 <6E21E5352C11B742B20C142EB499E048081EB789@TK5EX14MBXC124.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048081EB789@TK5EX14MBXC124.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 01:59:56PM +0000, KY Srinivasan wrote:
> Greg, sometime back you checked in the changes to the TODO file reflecting
> that there are no outstanding vmbus related issues. What is the process now
> for getting the vmbus (and util) drivers out of staging. Let me know if there is 
> something I can do to help this along.  As you know, we had posted the network 
> driver for public review a while ago (several months ago) and we have addressed 
> all the review comments we got. Any guidance on what we should do next would be
> greatly appreciated.

At this point in time, just ask me, and I will move the files.

So, to confirm, you want to have the following files moved to
drivers/hv/:
	drivers/staging/hv/Kconfig (part of this file)
	drivers/staging/hv/Makefile (part of this file)
	drivers/staging/hv/vmbus_drv.c
	drivers/staging/hv/hv.c
	drivers/staging/hv/connection.c
	drivers/staging/hv/channel.c
	drivers/staging/hv/channel_mgmt.c
	drivers/staging/hv/ring_buffer.c
	drivers/staging/hv/hv_util.c
	drivers/staging/hv/hv_kmp.c
	drivers/staging/hv/hv_kvp.h
	drivers/staging/hv/hyperv_vmbus.h

The following file moved to include/linux/:
	drivers/staging/hv/hyperv.h
(I think there is stuff in there that can go into hyperv_vmbus.h as it's
not needed in the "global" directory, but I can do that movement.)

The following file moved to tools/hv/:
	drivers/staging/hv/tools/*

And the following files modified to tie drivers/hv/ into the build service:
	drivers/Makefile
	drivers/Kconfig

Is all of that correct?

thanks,

greg k-h
