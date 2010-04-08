Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab0DHJCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 05:02:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34656 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756969Ab0DHJCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 05:02:08 -0400
Date: Thu, 8 Apr 2010 10:01:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Claudio Scordino <claudio@evidence.eu.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       John Nicholls <john@thinlinx.com>, Rick Bronson <rick@efn.org>,
       Sebastian Heutling <Sebastian.Heutling@who-ing.de>,
       michael trimarchi <michael@evidence.eu.com>, alan@lxorguk.ukuu.org.uk,
       hskinnemoen@atmel.com, linux@maxim.org.za
Subject: Re: [PATCH] atmel_serial: Atmel RS485 support v2
Message-ID: <20100408090114.GA31407@n2100.arm.linux.org.uk>
References: <4BB053C4.7050700@evidence.eu.com> <4BB10304.6090006@bluewatersys.com> <4BB1BF49.2000609@evidence.eu.com> <4BB252E3.3030703@bluewatersys.com> <4BBD8C9D.3070401@evidence.eu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBD8C9D.3070401@evidence.eu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 09:58:21AM +0200, Claudio Scordino wrote:
> diff --git a/arch/arm/include/asm/ioctls.h b/arch/arm/include/asm/ioctls.h
> index a91d8a1..82f2177 100644
> --- a/arch/arm/include/asm/ioctls.h
> +++ b/arch/arm/include/asm/ioctls.h
> @@ -70,6 +70,8 @@
>  #define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
>  #define FIOQSIZE	0x545E
>  
> +#define TIOCSRS485	0x5461

Why are you only supporting half the interface?

#define TIOCGRS485      0x542E
#define TIOCSRS485      0x542F

is what is in include/asm-generic/ioctls.h - and it would be a good idea
to use the same numbering as the generic file rather than creating yet
more divergence.
