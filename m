Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab1EEU2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 16:28:16 -0400
Received: from kroah.org ([198.145.64.141]:52778 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331Ab1EEU2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 16:28:15 -0400
Date: Thu, 5 May 2011 13:27:58 -0700
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] reboot: disable usermodehelper to prevent fs access
Message-ID: <20110505202758.GA12812@kroah.com>
References: <1304595126.1284.3.camel@zag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304595126.1284.3.camel@zag>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 01:32:05PM +0200, Kay Sievers wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: [PATCH] reboot: disable usermodehelper to prevent fs access
> 
> In case CONFIG_UEVENT_HELPER_PATH is not set to "", which it
> should be on every system, the kernel forks processes during
> shutdown, which try to access the rootfs, even when the
> binary does not exist. It causes exceptions and long delays in
> the disk driver, which gets read requests at the time it tries
> to shut down the disk.
> 
> This patch disables all kernel-forked processes during reboot to
> allow a clean poweroff.

Should this also be backported to the -stable kernels as people are
hitting this problem already today, right?

thanks,

greg k-h
