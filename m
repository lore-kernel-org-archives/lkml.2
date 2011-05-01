Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab1EAPja (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 11:39:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48159 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab1EAPj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 11:39:26 -0400
Date: Sun, 1 May 2011 11:39:21 -0400
From: Christoph Hellwig <hch@infradead.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>, Greg KH <greg@kroah.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
Message-ID: <20110501153920.GA15210@infradead.org>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <20110426232843.GA31184@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DD185@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110427064550.GA597@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481DD266@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110427121856.GA20633@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481DD676@TK5EX14MBXC124.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481DD676@TK5EX14MBXC124.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 04:32:35PM +0000, KY Srinivasan wrote:
> On the host-side, as part of configuring a guest  you can specify block devices
> as being under an IDE controller or under a
> SCSI controller. Those are the only options you have. Devices configured under
> the IDE controller cannot be seen in the guest under the emulated SCSI front-end which is
> the scsi driver (storvsc_drv). So, when you do a bus scan in the emulated scsi front-end,
> the devices enumerated will not include block devices configured under the IDE 
> controller. So, it is not clear to me how I can do what you are proposing given the 
> restrictions imposed by the host.

Just because a device is not reported by REPORT_LUNS doesn't mean you
can't talk to it using a SCSI LLDD.  We have SCSI transports with all
kinds of strange ways to discover devices.  Using scsi_add_device you
can add LUNs found by your own discovery methods, and use all the
existing scsi command handling.

