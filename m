Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2LNLux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 06:50:53 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57798 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab2LNLuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 06:50:51 -0500
Date: Fri, 14 Dec 2012 12:50:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-kernel@vger.kernel.org, Denis Kirjanov <kirjanov@gmail.com>
Subject: Re: [PATCH 12/12] edac: fix kernel panic on module unloading
Message-ID: <20121214115048.GB7307@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>,
	linux-kernel@vger.kernel.org, Denis Kirjanov <kirjanov@gmail.com>
References: <20121214110229.11019.63713.stgit@zurg>
 <20121214110310.11019.21098.stgit@zurg>
 <20121214112657.6c1b74e9@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121214112657.6c1b74e9@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 11:26:57AM +0000, Alan Cox wrote:
> On Fri, 14 Dec 2012 15:03:10 +0400
> Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:
> 
> > This patch fixes use-after-free and double-free bugs in edac_mc_sysfs_exit().
> > mci_pdev has single reference and put_device() calls mc_attr_release() which
> > calls kfree(), thus following device_del() works with already released memory.
> > An another kfree() in edac_mc_sysfs_exit() releses the same memory again. Great.
> 
> Patches for this were posted a while ago by Jean Delvare. See bugzilla
> 50491 as well for this.

Jean's patch is for i7core_edac but Konstantin's fixes the edac_core
which is another module. And AFAICT the correct order of destroying
devices in the driver core is

1. _del
2. _put

so I'll pick up Konstantin's patch with a tag for 3.7-stable unless
someone has objections?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
