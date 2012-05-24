Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab2EXKrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 06:47:52 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:29286 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab2EXKrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 06:47:51 -0400
X-IronPort-AV: E=Sophos;i="4.75,649,1330905600"; 
   d="scan'208";a="12646403"
Date: Thu, 24 May 2012 11:47:12 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 2/4] xen/hvc: Fix error cases around
 HVM_PARAM_CONSOLE_PFN
In-Reply-To: <1337795222-29946-3-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.00.1205241145200.26786@kaball-desktop>
References: <1337795222-29946-1-git-send-email-konrad.wilk@oracle.com> <1337795222-29946-3-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, Konrad Rzeszutek Wilk wrote:
> We weren't resetting the parameter to be passed in to a
> known default. Nor were we checking the return value of
> hvm_get_parameter.
> 
> CC: stable@kernel.org
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>
>  drivers/tty/hvc/hvc_xen.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
> index afc7fc2..3277f0e 100644
> --- a/drivers/tty/hvc/hvc_xen.c
> +++ b/drivers/tty/hvc/hvc_xen.c
> @@ -219,7 +219,8 @@ static int xen_hvm_console_init(void)
>  	if (r < 0)
>  		goto err;
>  	info->evtchn = v;
> -	hvm_get_parameter(HVM_PARAM_CONSOLE_PFN, &v);
> +	v = 0;
> +	r = hvm_get_parameter(HVM_PARAM_CONSOLE_PFN, &v);
>  	if (r < 0)
>  		goto err;
>  	mfn = v;

Is 0 the right default here?
Maybe something invalid like (~0UL) would be better?
