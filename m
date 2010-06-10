Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab0FJFu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 01:50:29 -0400
Received: from chipmunk.wormnet.eu ([195.195.131.226]:52915 "EHLO
	chipmunk.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab0FJFu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 01:50:28 -0400
Date: Thu, 10 Jun 2010 06:50:26 +0100
From: Alexander Clouter <alex@digriz.org.uk>
To: Dmytro Milinevskyy <milinevskyy@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
       Russell King <linux@arm.linux.org.uk>,
       Dhaval Vasa <dhaval.vasa@einfochips.com>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Nicolas Pitre <nico@fluxnic.net>, Simon Guinot <sguinot@lacie.com>,
       Martin Michlmayr <tbm@cyrius.com>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Marvell OpenRD-Ultimate machine support
Message-ID: <20100610055026.GM7660@chipmunk>
References: <4c104d7a.0c3ddf0a.2185.329a@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c104d7a.0c3ddf0a.2185.329a@mx.google.com>
Organization: diGriz
X-URL: http://www.digriz.org.uk/
X-JabberID: alex@digriz.org.uk
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Dmytro Milinevskyy <milinevskyy@gmail.com> [2010-06-10 05:24:56+0300]:
>
> [snipped]
>
> @@ -84,8 +90,7 @@ static void __init openrd_init(void)
>  
>  static int __init openrd_pci_init(void)
>  {
> -	if (machine_is_openrd_base() || machine_is_openrd_client())
> -		kirkwood_pcie_init();
> +	kirkwood_pcie_init();
>  
>  	return 0;
>  }
>
You just 'broke' kirkwood, welcome to the club.  We all have done this:

http://marc.info/?l=linux-arm-kernel&m=125624586625065&w=2
http://marc.info/?l=linux-arm-kernel&m=125804222219159&w=2

Put that 'if()' clause back in, the 'subsys_initcall(openrd_pci_init)' 
causes that code to run on *all* compiled in boards (think of the case 
where you have SheevaPlug's also enabled).

Cheers

-- 
Alexander Clouter
.sigmonster says: Poverty begins at home.
