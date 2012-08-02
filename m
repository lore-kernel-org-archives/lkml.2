Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab2HBHgE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 03:36:04 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:25474 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab2HBHfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 03:35:53 -0400
X-IronPort-AV: E=Sophos;i="4.77,699,1336348800"; 
   d="scan'208";a="13815371"
Message-ID: <1343892951.7571.50.camel@dagon.hellion.org.uk>
Subject: Re: [PATCH 01/24] arm: initial Xen support
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Rob Herring <robherring2@gmail.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 2 Aug 2012 08:35:51 +0100
In-Reply-To: <50197527.3070007@gmail.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
	 <1343316846-25860-1-git-send-email-stefano.stabellini@eu.citrix.com>
	 <50197527.3070007@gmail.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-01 at 19:27 +0100, Rob Herring wrote:
> On 07/26/2012 10:33 AM, Stefano Stabellini wrote:
> > - Basic hypervisor.h and interface.h definitions.
> > - Skelethon enlighten.c, set xen_start_info to an empty struct.
> > - Do not limit xen_initial_domain to PV guests.
> > 
> > The new code only compiles when CONFIG_XEN is set, that is going to be
> > added to arch/arm/Kconfig in a later patch.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  arch/arm/Makefile                     |    1 +
> >  arch/arm/include/asm/hypervisor.h     |    6 +++
> >  arch/arm/include/asm/xen/hypervisor.h |   19 ++++++++++
> >  arch/arm/include/asm/xen/interface.h  |   64 +++++++++++++++++++++++++++++++++
> 
> These headers don't seem particularly ARM specific. Could they be moved
> to asm-generic or include/linux?

Or perhaps include/xen.

A bunch of it also looks like x86 specific stuff which has crept in.
e.g. PARAVIRT_LAZY_FOO and paravirt_get_lazy_mode() are arch/x86
specific and shouldn't be called from common code (and aren't, AFAICT).



