Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933042Ab1BYW4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 17:56:30 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:36799 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932539Ab1BYW42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 17:56:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=hM2IYSw0NJgOr6sEi9CfP8SWb+ETQe1bkWyKkcWnAqGlY6Dqgw+FsbDoI+yciXnNSw2crtwztHuhA1Jf8TEoXA/HYCKilkQGLTl+oBpkJRHt19J56OYL6CyrAYysM/io;
Date: Fri, 25 Feb 2011 14:56:21 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        clemens@ladisch.de, Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH 3/4] PCI: introduce reset_resource()
Message-ID: <20110225145621.6f2facc4@jbarnes-desktop>
In-Reply-To: <1297734200-23327-4-git-send-email-linuxram@us.ibm.com>
References: <1297734200-23327-1-git-send-email-linuxram@us.ibm.com>
	<1297734200-23327-4-git-send-email-linuxram@us.ibm.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011 17:43:19 -0800
Ram Pai <linuxram@us.ibm.com> wrote:

> introduced reset_resource() which factors out resource reset logic.
> 
>     Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> ---
>  drivers/pci/setup-bus.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index bcf5752..a94ecc1 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -88,6 +88,13 @@ static void __dev_sort_resources(struct pci_dev *dev,
>  	pdev_sort_resources(dev, head);
>  }
>  
> +static inline void reset_resource(struct resource *res)
> +{
> +	res->start = 0;
> +	res->end = 0;
> +	res->flags = 0;
> +}
> +

Probably belongs in resource.c, and there may be other users that can
be cleaned up as well.  Nice improvement to readability.

-- 
Jesse Barnes, Intel Open Source Technology Center
