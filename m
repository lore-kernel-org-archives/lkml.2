Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab0LJVHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 16:07:00 -0500
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:34505 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753056Ab0LJVG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 16:06:58 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=WAL1nJI4Iaj70Klkppl+Zzqfo9qGT6eC5JGbXh174D/ROfy1GezmXapc3O9Z9EXNoc6JsZDFFY6B7sbLZKmMFB5RupowOcRE5aVjqeeIZuop0tzNvaTPUO96VlDGDXy/;
Date: Fri, 10 Dec 2010 13:06:56 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pci: Skip id checking if no id is passed
Message-ID: <20101210130656.6dc39b79@jbarnes-desktop>
In-Reply-To: <4CE436C0.5050802@kernel.org>
References: <4CE436C0.5050802@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010 12:10:40 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> Will get warning when pci stub driver is built-in kenel like:
> pci-stub: invalid id string ""
> 
> So stop early if no id is passed.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/pci-stub.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: linux-2.6/drivers/pci/pci-stub.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci-stub.c
> +++ linux-2.6/drivers/pci/pci-stub.c
> @@ -47,6 +47,10 @@ static int __init pci_stub_init(void)
>  	if (rc)
>  		return rc;
>  
> +	/* no ids passed actually */
> +	if (ids[0] == '\0')
> +		return 0;
> +
>  	/* add ids specified in the module parameter */
>  	p = ids;
>  	while ((id = strsep(&p, ","))) {
> 

Applied to linux-next, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
