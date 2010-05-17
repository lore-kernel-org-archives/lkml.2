Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab0EQLh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 07:37:59 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:56013 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab0EQLh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 07:37:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=QBgIgzlSFpqWDMcTV0riCvm5H+sMTYIXQzWfas0RxyFmkeXb3RJcTpc6PHl+WnBzvK
         tKu8axTbeVBvgiwfqpBrpr/5y/qR7BokzGvfpTelIX8h9rtX2rNRFQH/9NkWkTNHUaA6
         USY9mC9dIXi/UA487b96Yzj4oIxBcZuekWbWw=
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86: CPU detection for RDC System-on-Chip
Date: Mon, 17 May 2010 13:39:48 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-server; KDE/4.4.2; x86_64; ; )
Cc: mingo@elte.hu, "linux-kernel" <linux-kernel@vger.kernel.org>
References: <201005161455.34100.florian@openwrt.org> <20100517112358.GD20761@basil.fritz.box>
In-Reply-To: <20100517112358.GD20761@basil.fritz.box>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005171339.48936.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 May 2010 13:23:58 Andi Kleen wrote:
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 39e8e10..21b02f2 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -419,6 +419,7 @@ config X86_RDC321X
> > 
> >  	bool "RDC R-321x SoC"
> >  	depends on X86_32
> >  	depends on X86_EXTENDED_PLATFORM
> > 
> > +	select PCI
> 
> If you don't actually need PCI in your SOC then you could easily
> remove that dependency with some minor work. Early PCI really is quite
> independent from the other code and can be just used on its own.

We actually do need PCI for the Ethernet MAC to work as well as the 
southbridge driver.

> 
> The only thing that would need sorting out is the command line
> interface for early_pci_enabled()
> 
> -Andi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
