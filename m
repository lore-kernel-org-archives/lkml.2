Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab0G3QsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 12:48:01 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:55970 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753615Ab0G3Qr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 12:47:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=naLRoPcm/mFJXmaa216YqtmlIYlP1Q6h5ECNvg1mZhjyuvpPb9b+qayGumJGlTrBoLPaeDEfVo9gURB5LIm6x1oguSo7Gd2h4b1U99WsKB5NTLKVumammjCgfGd9vC2y;
Date: Fri, 30 Jul 2010 09:47:55 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: Do not run NVidia quirks related to MSI with MSI
 disabled
Message-ID: <20100730094755.7f53b7d8@virtuousgeek.org>
In-Reply-To: <201007232219.55331.rjw@sisk.pl>
References: <201007232219.55331.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jul 2010 22:19:55 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> There is no reason to run NVidia-specific quirks related to HT MSI
> mappings with MSI disabled via pci=nomsi, so make
> __nv_msi_ht_cap_quirk() return immediately in that case.
> 
> This allows at least one machine to boot 100% of the time with
> pci=nomsi (it still doesn't boot reliably without that).
> 
> Addresses https://bugzilla.kernel.org/show_bug.cgi?id=16443 .
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/pci/quirks.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux-2.6/drivers/pci/quirks.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/quirks.c
> +++ linux-2.6/drivers/pci/quirks.c
> @@ -2390,6 +2390,9 @@ static void __devinit __nv_msi_ht_cap_qu
>  	int pos;
>  	int found;
>  
> +	if (!pci_msi_enabled())
> +		return;
> +
>  	/* check if there is HT MSI cap or enabled on this device */
>  	found = ht_check_msi_mapping(dev);

applied to linux-next with a cc: stable.  Thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
