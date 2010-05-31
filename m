Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab0EaL6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 07:58:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:42515 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582Ab0EaL6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 07:58:05 -0400
Date: Mon, 31 May 2010 13:58:02 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Stefan Achatz <erazor_de@users.sourceforge.net>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: [PATCH -next] hid: roccat modules interdependencies
In-Reply-To: <20100527090706.6c2bc555.randy.dunlap@oracle.com>
Message-ID: <alpine.LNX.2.00.1005311357540.28092@pobox.suse.cz>
References: <20100527152628.b23a14c6.sfr@canb.auug.org.au> <20100527090706.6c2bc555.randy.dunlap@oracle.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> hid-roccat-kone calls the hid-roccat module interfaces,
> so the former should depend on or select the latter to prevent
> build errors, like:
> 
> hid-roccat-kone.c:(.text+0x133ed2): undefined reference to `roccat_report_event'
> hid-roccat-kone.c:(.text+0x133fa8): undefined reference to `roccat_disconnect'
> hid-roccat-kone.c:(.text+0x1353be): undefined reference to `roccat_connect'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/hid/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20100527.orig/drivers/hid/Kconfig
> +++ linux-next-20100527/drivers/hid/Kconfig
> @@ -358,6 +358,7 @@ config HID_ROCCAT
>  config HID_ROCCAT_KONE
>  	tristate "Roccat Kone Mouse support"
>  	depends on USB_HID
> +	select HID_ROCCAT
>  	---help---
>  	Support for Roccat Kone mouse.

Applied, thanks Randy.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
