Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab0GEIOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 04:14:19 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:37718 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773Ab0GEIOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:14:17 -0400
Date: Mon, 5 Jul 2010 09:14:02 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Shane McDonald <mcdonald.shane@gmail.com>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 5/9] Removing dead CONFIG_BLK_DEV_IDE
Message-ID: <20100705081402.GB740@linux-mips.org>
References: <cover.1275925108.git.siccegge@cs.fau.de>
 <73e9e4bd7615488c9567f02f8962825386956365.1275925108.git.siccegge@cs.fau.de>
 <AANLkTillx50SaxZU2cT9YSlS4uRF_ED5-wlG-JwfXfFT@mail.gmail.com>
 <20100616113548.GA10065@faui48a.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616113548.GA10065@faui48a.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 01:35:48PM +0200, Christoph Egger wrote:

> On Thu, Jun 10, 2010 at 12:23:06PM -0600, Shane McDonald wrote:
> >   I wonder if, instead of deleting the code, the constant should be
> > changed from CONFIG_BLK_DEV_IDE to CONFIG_IDE.  The original
> > patch that removed CONFIG_BLK_DEV_IDE seemed to make this change:
> > http://kerneltrap.org/mailarchive/linux-kernel/2008/8/13/2929444
> > 
> > Shane
> 
> You're probably right, updated patch below
> 
> -------
> From: Christoph Egger <siccegge@cs.fau.de>
> Date: Mon, 7 Jun 2010 17:29:48 +0200
> Subject: [PATCH 5/9] Removing dead CONFIG_BLK_DEV_IDE
> 
> CONFIG_BLK_DEV_IDE doesn't exist in Kconfig, therefore removing all
> references for it from the source code.
> 
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> ---
> diff --git a/arch/mips/mti-malta/malta-setup.c
> b/arch/mips/mti-malta/malta-setup.c
> index b7f37d4..f6a5ea8 100644
> --- a/arch/mips/mti-malta/malta-setup.c
> +++ b/arch/mips/mti-malta/malta-setup.c
> @@ -105,7 +105,7 @@ static void __init fd_activate(void)
>  }
>  #endif
>  
> -#ifdef CONFIG_BLK_DEV_IDE
> +#ifdef CONFIG_IDE

This doesn't fly too well either.  CONFIG_BLK_DEV_IDE was a bool but
CONFIG_IDE is tristate.  But changing the ifdef to

#if defined(CONFIG_IDE) || defined(CONFIG_IDE_MODULE)

wouldn't really work either.  I think this needs some generic infrastructure
to get the PCI clock.

Or maybe this is just another reason to scrap IDE support.

  Ralf
