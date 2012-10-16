Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab2JPHVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:21:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:28208 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736Ab2JPHVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:21:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,593,1344236400"; 
   d="scan'208";a="206218732"
Date: Tue, 16 Oct 2012 15:21:43 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ACPI: move acpi_no_s4_hw_signature() declaration into
 #ifdef CONFIG_HIBERNATION
Message-ID: <20121016072143.GH1965@yliu-dev.sh.intel.com>
References: <1350365052-27304-1-git-send-email-yuanhan.liu@linux.intel.com>
 <20121016062453.GA1505@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121016062453.GA1505@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 02:24:53PM +0800, Fengguang Wu wrote:
> On Tue, Oct 16, 2012 at 01:24:12PM +0800, Yuanhan Liu wrote:
> > acpi_no_s4_hw_signature is defined in #ifdef CONFIG_HIBERNATION block,
> > but the current code put the declaration in #ifdef CONFIG_PM_SLEEP block.
> > 
> > I happened to meet this issue when I turned off PM_SLEEP config manually:
> > arch/x86/kernel/acpi/sleep.c:100:4: error: implicit declaration of function ‘acpi_no_s4_hw_signature’ [-Werror=implicit-function-declaration]
> 
> This should be more clear:
> 
> Fix build error on !CONFIG_PM_SLEEP:

Actually, there are more erros besides the followling one on !CONFIG_PM_SLEEP.
This patch just fix one obvious one: the logical is wrong.

Thanks,
Yuanhan Liu
> 
> arch/x86/kernel/acpi/sleep.c:100:4: error: implicit declaration of function ‘acpi_no_s4_hw_signature’
> 
> The root cause is, acpi_no_s4_hw_signature() is defined in
> #ifdef CONFIG_HIBERNATION block, but the current code put the
> declaration in #ifdef CONFIG_PM_SLEEP block.
> 
> Thanks,
> Fengguang
> 
> > v2: take better title and add build error message suggested by Fengguang
> > 
> > Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> > Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>
> > ---
> >  include/linux/acpi.h |    5 ++++-
> >  1 files changed, 4 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> > index 90be989..a468429 100644
> > --- a/include/linux/acpi.h
> > +++ b/include/linux/acpi.h
> > @@ -257,8 +257,11 @@ int acpi_check_region(resource_size_t start, resource_size_t n,
> >  
> >  int acpi_resources_are_enforced(void);
> >  
> > -#ifdef CONFIG_PM_SLEEP
> > +#ifdef CONFIG_HIBERNATION
> >  void __init acpi_no_s4_hw_signature(void);
> > +#endif
> > +
> > +#ifdef CONFIG_PM_SLEEP
> >  void __init acpi_old_suspend_ordering(void);
> >  void __init acpi_nvs_nosave(void);
> >  #endif /* CONFIG_PM_SLEEP */
> > -- 
> > 1.7.7.6
