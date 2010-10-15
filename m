Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab0JOTys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 15:54:48 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:50244 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932414Ab0JOTyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 15:54:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=eg6IG4EmI6vy3JWYU/YnGCyZRJjpg1n/JJiS1Q0WWCBlJRdza94YdWeAIhZJskh3IgPX6Kc6G0/xtXr9BUy/x+Hrv+PhSujLTfHr5a7aPdf7x/zo3QMd2nfZI+ByMYEt;
Date: Fri, 15 Oct 2010 12:54:28 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Seth Heasley <seth.heasley@intel.com>
Cc: khali@linux-fr.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 2.6.35.4] irq: irq and pci_ids patch for Intel Patsburg
Message-ID: <20101015125428.01120a8d@jbarnes-desktop>
In-Reply-To: <201010041327.15170.seth.heasley@intel.com>
References: <201009241606.11840.seth.heasley@intel.com>
	<201010041327.15170.seth.heasley@intel.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Oct 2010 13:27:14 -0700
Seth Heasley <seth.heasley@intel.com> wrote:

> >> --- linux-2.6.35.4/drivers/i2c/busses/Kconfig.orig   2010-09-24
> >14:59:23.000000000 -0700
> >> +++ linux-2.6.35.4/drivers/i2c/busses/Kconfig        2010-09-24
> >14:59:42.000000000 -0700
> >> @@ -95,7 +95,7 @@
> >>          ESB2
> >>          ICH8
> >>          ICH9
> >> -        Tolapai
> >> +        EP80579
> >>          ICH10
> >>          3400/5 Series (PCH)
> >
> >How did this become "5_3400_SERIES" in the symbol names? Shouldn't it
> >be 3400_5_SERIES instead?
> 
> The approved branding in pci.ids is 5/3400 Series, so I wanted to reflect that here.  I've changed it in Kconfig as well as i2c-i801.c to be consistent.
> 
> >> --- linux-2.6.35.4/drivers/i2c/busses/i2c-i801.c.orig        2010-09-24
> >14:57:55.000000000 -0700
> >> +++ linux-2.6.35.4/drivers/i2c/busses/i2c-i801.c     2010-09-24
> >14:59:13.000000000 -0700
> >> @@ -38,7 +38,7 @@
> >>    82801G   (ICH7)       0x27da     32     hard     yes     yes
> >yes
> >>    82801H   (ICH8)       0x283e     32     hard     yes     yes
> >yes
> >>    82801I   (ICH9)       0x2930     32     hard     yes     yes
> >yes
> >> -  Tolapai               0x5032     32     hard     yes     yes
> >yes
> >> +  EP80579               0x5032     32     hard     yes     yes
> >yes
> >
> >Maybe keep "Tolapai" inside parentheses, as people may know the
> >platform by that name by now?
> 
> Agreed.  I've updated that in both places it's referenced.  Final (hopefully) patch below:
> 
> This patch updates the defines for Intel devices in include/linux/pci_ids.h, referenced in arch/x86/pci/irq.c and drivers/i2c/busses/i2c-i801.c, reflecting approved legal branding, and using fuller code-names for products under development.
>  
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>

Applied this update, thanks.

Note that going forward I don't expect (or want!) patches to convert
the development names into marketing names.  We should just add new
stuff with the development names (before the product ships) and leave
them that way to avoid unnecessary churn.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
