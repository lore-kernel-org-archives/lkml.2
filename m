Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab1BPTq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 14:46:28 -0500
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:39056 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754014Ab1BPTqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 14:46:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Y22dO6MsR7nETlD+tsugvKUDjII/w/bAEp/MTlrxL7qdYKsrqRhrDOb/8NjvvaNLeh3YxScMvWhIKF43m+FTu2XUD9tO6il+YDX0cS6nbw6uu8JxVmND+xOC7UMsCOaj;
Date: Wed, 16 Feb 2011 11:46:19 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>,
        linux-pci@vger.kernel.org, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, davem@davemloft.net,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH -next] PCI: fix tlan build when CONFIG_PCI is not
 enabled
Message-ID: <20110216114619.7fbfb3cf@jbarnes-desktop>
In-Reply-To: <20110214122750.e1e03bc8.randy.dunlap@oracle.com>
References: <20110214181137.ee8d4c08.sfr@canb.auug.org.au>
	<20110214122750.e1e03bc8.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011 12:27:50 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> When CONFIG_PCI is not enabled, tlan.c has a build error:
> drivers/net/tlan.c:503: error: implicit declaration of function 'pci_wake_from_d3'
> 
> so add an inline function stub for this function to pci.h when
> PCI is not enabled, similar to other stubbed PCI functions.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  include/linux/pci.h |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> --- linux-next-20110214.orig/include/linux/pci.h
> +++ linux-next-20110214/include/linux/pci.h
> @@ -1191,6 +1191,11 @@ static inline int pci_set_power_state(st
>  	return 0;
>  }
>  
> +static inline int pci_wake_from_d3(struct pci_dev *dev, bool enable)
> +{
> +	return 0;
> +}
> +
>  static inline pci_power_t pci_choose_state(struct pci_dev *dev,
>  					   pm_message_t state)
>  {
> 

Applied to linux-next, thanks guys.

-- 
Jesse Barnes, Intel Open Source Technology Center
