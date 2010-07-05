Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab0GEL6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 07:58:33 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:29645 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab0GEL6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 07:58:31 -0400
X-IronPort-AV: E=Sophos;i="4.53,539,1272844800"; 
   d="scan'208";a="740278"
Date: Mon, 5 Jul 2010 12:58:52 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Don Dutile <ddutile@redhat.com>
CC: "stefano@stabellini.net" <stefano@stabellini.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "sheng@linux.intel.com" <sheng@linux.intel.com>,
       "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [PATCH 12/13] Unplug emulated disks and nics
In-Reply-To: <4C2CEF56.4050008@redhat.com>
Message-ID: <alpine.DEB.2.00.1007051255310.29110@kaball-desktop>
References: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop> <1277136847-13266-12-git-send-email-stefano@stabellini.net> <4C2CEF56.4050008@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jul 2010, Don Dutile wrote:
> The problem with this check/enable is that if you run
> this on an older qemu-xen that doesn't have unplug support,
> it fails pv-hvm configuration.
> 
> But, all that means is that you can't use an xvd as the boot device,
> and you have to use an emulated IDE device as boot device.
> There are a couple ways to configure the vnif correctly (in guest
> or in xen guest config file).
> 
> So, on an older (say, rhel5) xen, I don't have this check;
> the boot device is required to be spec'd as hda, not vda, and
> xen-blkfront is not allowed to configure blk major nums
> for IDE (& SCSI) (to avoid 2 drivers twiddling w/same phys backend... not good!).
> 

Who is requiring that the boot device is spec'd as hda and not xvda?
I don't think there is such limitation in xend or libxl at the moment.

