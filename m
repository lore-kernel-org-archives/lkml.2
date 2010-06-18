Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933838Ab0FRRZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 13:25:09 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:34158 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933813Ab0FRRZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 13:25:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=VyMOB1eRrm8ryC0mbfOZ9jw8WO8WhGq4hn7iOP+t+SN5JfuEvedVrtWZ6rZJPm9x/e4SuACE4TieyPmzVfyEtSnS23JXbB0APh7hS39xoLhOXzb13mcxINP6s/FSW6Z3;
Date: Fri, 18 Jun 2010 10:23:30 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 4/5]pci:setup_bus.c Fix warning: variable 'retval' set
 but not used
Message-ID: <20100618102330.29eccb5b@virtuousgeek.org>
In-Reply-To: <1276666434-11227-5-git-send-email-justinmattock@gmail.com>
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>
	<1276666434-11227-5-git-send-email-justinmattock@gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jun 2010 22:33:53 -0700
"Justin P. Mattock" <justinmattock@gmail.com> wrote:

> The below patch fixes a warning message when using gcc 4.6.0
>   CC      drivers/pci/setup-bus.o
> drivers/pci/setup-bus.c: In function 'pci_assign_unassigned_bridge_resources':
> drivers/pci/setup-bus.c:868:6: warning: variable 'retval' set but not used
>  
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  drivers/pci/setup-bus.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 19b1113..215590b 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -865,7 +865,6 @@ void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
>  	struct pci_bus *parent = bridge->subordinate;
>  	int tried_times = 0;
>  	struct resource_list_x head, *list;
> -	int retval;
>  	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
>  				  IORESOURCE_PREFETCH;
>  
> @@ -874,7 +873,6 @@ void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
>  again:
>  	pci_bus_size_bridges(parent);
>  	__pci_bridge_assign_resources(bridge, &head);
> -	retval = pci_reenable_device(bridge);
>  	pci_set_master(bridge);
>  	pci_enable_bridges(parent);
>  

This has the same problem as your earlier bridge_enable patch; you need
to keep the call to pci_reenable_device.  I should have caught this
issue when Yinghai's patch went in: the right way to silence a warning
about not checking a return value isn't to simply assign it to
something, you really should *do* something as well, at least some
debug output would be nice, but ideally handling the error in a sane
way. 

-- 
Jesse Barnes, Intel Open Source Technology Center
