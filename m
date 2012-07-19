Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab2GSXz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 19:55:28 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46562 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752022Ab2GSXzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 19:55:25 -0400
X-Sasl-enc: DlRFfvgoIMLtZV3hx4xrJbmueRG7Ltm8qRt85HE2Obat 1342742124
Date: Thu, 19 Jul 2012 16:55:23 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: linux-next: manual merge of the staging tree with the
 target-merge tree
Message-ID: <20120719235523.GA13623@kroah.com>
References: <20120719145301.b8992aa986b47d7c44651710@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120719145301.b8992aa986b47d7c44651710@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 02:53:01PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/Kconfig between commit d0146d396bfa ("tcm_vhost: Initial
> merge for vhost level target fabric driver") from the target-merge tree
> and commit 15a4bc17b7f4 ("Staging: add CSR Wifi "os helper" module") from
> the staging tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/staging/Kconfig
> index 67ec9fe,e3402d5..0000000
> --- a/drivers/staging/Kconfig
> +++ b/drivers/staging/Kconfig
> @@@ -132,6 -132,8 +132,10 @@@ source "drivers/staging/ipack/Kconfig
>   
>   source "drivers/staging/gdm72xx/Kconfig"
>   
> + source "drivers/staging/csr/Kconfig"
> + 
> + source "drivers/staging/omap-thermal/Kconfig"
> + 
>  +source "drivers/vhost/Kconfig.tcm"

Why is someone putting a non drivers/staging/ Kconfig file here in
drivers/staging/Kconfig?  That's not ok at all.

Target people, please just depend on CONFIG_STAGING if you want to do
that, but don't mess with files in the drivers/staging/ directory for no
good reason at all.

thanks,

greg k-h
