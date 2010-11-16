Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab0KPFvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 00:51:43 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:60585 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab0KPFvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 00:51:42 -0500
Date: Tue, 16 Nov 2010 14:51:09 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: /dev/sda disappearing with SYFS_DEPRECATED?
Message-ID: <20101116055108.GB1064@linux-sh.org>
References: <20101116052027.GB24410@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116052027.GB24410@gamma.logic.tuwien.ac.at>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 02:20:27PM +0900, Norbert Preining wrote:
> I just changed my kernel config slightly to activate some DEPRECATED
> configs and alas, the change was interesting, suddenly there
> was no /dev/sda shown anymore.
> 
> Userspace remain completely the same (debian/sid up2date).
> 
> The only changes I made in the .config file was:
> -# CONFIG_SYSFS_DEPRECATED is not set
> +CONFIG_SYSFS_DEPRECATED=y
> +CONFIG_SYSFS_DEPRECATED_V2=y
> 
> -CONFIG_NFSD_DEPRECATED=y
> +# CONFIG_NFSD_DEPRECATED is not set
> 
> and this made the /dev/sda* entries disappear.
> 
> Is that to be expected?
> 
Yes. Newer tools are incompatible with these settings, as noted in the
Kconfig help for these entries:

config SYSFS_DEPRECATED

	...

          Recent distributions and userspace tools after 2009/2010 depend on
          the existence of /sys/class/block/, and will not work with this
          option enabled.

SYSFS_DEPRECATED_V2 just forces this behaviour on.
