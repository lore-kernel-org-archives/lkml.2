Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab0KYNNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 08:13:32 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47350 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab0KYNNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 08:13:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vto/ZBZg8iwcSTAClt3YrtnZIIQvnv/NgwKcXSN2rOVxwSEO6Haq0uwzQqWkBXnaXr
         gQDRwOC6baWDzBGRpD0ih0U2V1cPZeL865toQnmoEw+d4yhfC/W83VM0SPZP+fWyA17z
         b111ht0m3UmafSJyJ3NEiCVivUphuHTSaZp6U=
Date: Thu, 25 Nov 2010 16:12:24 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: mkl0301@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dbrownell@users.sourceforge.net, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 3/3] USB: cns3xxx: Add EHCI and OHCI bus glue for
 cns3xxx SOCs
Message-ID: <20101125131224.GA15916@oksana.dev.rtsoft.ru>
References: <1290443565-20766-1-git-send-email-mkl0301@gmail.com>
 <1290443565-20766-4-git-send-email-mkl0301@gmail.com>
 <20101124162512.GB10890@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101124162512.GB10890@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 07:25:12PM +0300, Anton Vorontsov wrote:
> On Tue, Nov 23, 2010 at 12:32:45AM +0800, mkl0301@gmail.com wrote:
> > From: Mac Lin <mkl0301@gmail.com>
> > 
> > The CNS3XXX SOC has include USB EHCI and OHCI compatible controllers. This
> > patch adds the necessary glue logic to allow ehci-hcd and ohci-hcd drivers to
> > work on CNS3XXX
> > 
> > The EHCI and OHCI controllers share a common clock control and reset bit,
> > therefore additional check for the timming of enabling and disabling is
> > required. The USB bit of PLL Power Down Control is also shared by OTG, 24MHz
> > UART clock, Crypto clock, PCIe reference clock, and Clock Scale Generator.
> > Therefore we only ensure it is enabled, while not disabling it.
> > 
> > Signed-off-by: Mac Lin <mkl0301@gmail.com>
> 
> Thanks for the patch!
> 
> A few (mostly cosmetic) comments down below.
[...]
> > +#ifdef CNS3XXX_USB_BASE_VIRT
> > +	hcd->regs = (void __iomem *) CNS3XXX_USB_BASE_VIRT;
> > +#else

Oh, and also. Please get rid of these #ifdefs. There is no
CNS3XXX_USB_BASE_VIRT anymore. So, just remove them.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
