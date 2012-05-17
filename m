Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761334Ab2EQIE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 04:04:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39418 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761316Ab2EQIDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 04:03:50 -0400
Date: Thu, 17 May 2012 10:03:41 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com
Subject: Re: [PATCH 1/1] Drivers: hid: hid-hyperv.c: Set the hid drvdata
 correctly
In-Reply-To: <1337201413-9857-1-git-send-email-kys@microsoft.com>
Message-ID: <alpine.LNX.2.00.1205171003340.8796@pobox.suse.cz>
References: <1337201413-9857-1-git-send-email-kys@microsoft.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2012, K. Y. Srinivasan wrote:

> Set the hid drvdata prior to invoking hid_add_device() as hid_add_device()
> expects this state to be set. This bug was introduced in the recent hid
> changes that were made in:
> 
> commit 07d9ab4f0e52cb2a383596e5ebbbd20232501393
> HID: hid-hyperv: Do not use hid_parse_report() directly
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/hid/hid-hyperv.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
> index 032e6c0..3d62781 100644
> --- a/drivers/hid/hid-hyperv.c
> +++ b/drivers/hid/hid-hyperv.c
> @@ -516,11 +516,12 @@ static int mousevsc_probe(struct hv_device *device,
>  
>  	sprintf(hid_dev->name, "%s", "Microsoft Vmbus HID-compliant Mouse");
>  
> +	hid_set_drvdata(hid_dev, device);
> +
>  	ret = hid_add_device(hid_dev);
>  	if (ret)
>  		goto probe_err1;
>  
> -	hid_set_drvdata(hid_dev, device);
>  
>  	ret = hid_parse(hid_dev);
>  	if (ret) {

Applied, thanks KY.

-- 
Jiri Kosina
SUSE Labs
