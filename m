Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab1BJIXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 03:23:41 -0500
Received: from tundra.namei.org ([65.99.196.166]:37526 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab1BJIXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 03:23:39 -0500
Date: Thu, 10 Feb 2011 19:23:07 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Chris Wright <chrisw@sous-sol.org>
cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Eric Paris <eparis@redhat.com>, Don Dutile <ddutile@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/2] pci: use security_capable() when checking capablities
 during config space read
In-Reply-To: <1297318312-14309-3-git-send-email-chrisw@sous-sol.org>
Message-ID: <alpine.LRH.2.00.1102101915000.20298@tundra.namei.org>
References: <1297318312-14309-1-git-send-email-chrisw@sous-sol.org> <1297318312-14309-3-git-send-email-chrisw@sous-sol.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Feb 2011, Chris Wright wrote:

> Eric Paris noted that commit de139a3 ("pci: check caps from sysfs file
> open to read device dependent config space") caused the capability check
> to bypass security modules and potentially auditing.  Rectify this by
> calling security_capable() when checking the open file's capabilities
> for config space reads.

What about these other users of cap_raised?

drivers/block/drbd/drbd_nl.c:   if (!cap_raised(nsp->eff_cap, CAP_SYS_ADMIN)) {
drivers/md/dm-log-userspace-transfer.c: if (!cap_raised(nsp->eff_cap, CAP_SYS_ADMIN))
drivers/staging/pohmelfs/config.c:      if (!cap_raised(nsp->eff_cap, CAP_SYS_ADMIN))
drivers/video/uvesafb.c:        if (!cap_raised(nsp->eff_cap, CAP_SYS_ADMIN))


Also, should this have a reported-by for Eric ?

-- 
James Morris
<jmorris@namei.org>
