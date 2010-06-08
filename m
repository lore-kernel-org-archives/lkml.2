Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab0FHRi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 13:38:56 -0400
Received: from mail.perches.com ([173.55.12.10]:2786 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210Ab0FHRiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 13:38:55 -0400
Subject: Re: [PATCH] Marvell OpenRD-Ultimate machine support
From: Joe Perches <joe@perches.com>
To: Dmytro Milinevskyy <milinevskyy@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
       Russell King <linux@arm.linux.org.uk>,
       Dhaval Vasa <dhaval.vasa@einfochips.com>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Nicolas Pitre <nico@fluxnic.net>, Simon Guinot <sguinot@lacie.com>,
       Martin Michlmayr <tbm@cyrius.com>,
       Alexander Clouter <alex@digriz.org.uk>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4c0e7d5a.0c3ddf0a.2771.ffffd485@mx.google.com>
References: <4c0e7d5a.0c3ddf0a.2771.ffffd485@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Jun 2010 10:38:51 -0700
Message-ID: <1276018731.1571.518.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-08 at 20:24 +0300, Dmytro Milinevskyy wrote:
> @@ -73,9 +81,14 @@ static void __init openrd_init(void)
>  
>  	kirkwood_ehci_init();
>  
> -	kirkwood_ge00_init(&openrd_ge00_data);
> -	if (machine_is_openrd_client())
> -		kirkwood_ge01_init(&openrd_ge01_data);
> +	if (machine_is_openrd_ultimate()) {
> +		kirkwood_ge00_init(&openrd_ultimate_ge00_data);
> +		kirkwood_ge01_init(&openrd_ultimate_ge01_data);
> +	} else {
> +		kirkwood_ge00_init(&openrd_ge00_data);
> +		if (machine_is_openrd_client())
> +			kirkwood_ge01_init(&openrd_ge01_data);
> +	}

Perhaps some utility functions like:

	if (kirkwood_has_multiple_ethernets())?

> @@ -84,7 +97,7 @@ static void __init openrd_init(void)
>  
>  static int __init openrd_pci_init(void)
>  {
> -	if (machine_is_openrd_base() || machine_is_openrd_client())
> +	if (machine_is_openrd_base() || machine_is_openrd_client() || machine_is_openrd_ultimate())

	if (kirkwood_has_pcie()?


