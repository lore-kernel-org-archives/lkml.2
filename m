Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab2GRErI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 00:47:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64888 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab2GRErD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 00:47:03 -0400
Date: Tue, 17 Jul 2012 21:46:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: thomas.abraham@linaro.org, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, sameo@linux.intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 1/2] mfd: add irq domain support for max8997
 interrupts
Message-ID: <20120718044656.GB10619@kroah.com>
References: <1341187375-16333-1-git-send-email-cw00.choi@samsung.com>
 <20120717163427.GA3756@kroah.com>
 <500615D4.1020002@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500615D4.1020002@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 10:48:04AM +0900, Chanwoo Choi wrote:
> On 07/18/2012 01:34 AM, Greg KH wrote:
> 
> > On Mon, Jul 02, 2012 at 09:02:55AM +0900, Chanwoo Choi wrote:
> >> From: Thomas Abraham <thomas.abraham@linaro.org>
> >>
> >> Add irq domain support for max8997 interrupts. The reverse mapping method
> >> used is linear mapping since the sub-drivers of max8997 such as regulator
> >> and charger drivers can use the max8997 irq_domain to get the linux irq
> >> number for max8997 interrupts. All uses of irq_base in platform data and
> >> max8997 driver private data are removed.
> >>
> >> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> >> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> >> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> >> Acked-by: Samuel Ortiz <sameo@linux.intel.com>
> >> 	[Fix two bug which set max8997->irq_domain and correct wrong parameter]
> >> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> ---
> >>  arch/arm/mach-exynos/mach-nuri.c    |    4 --
> >>  arch/arm/mach-exynos/mach-origen.c  |    1 -
> >>  drivers/mfd/Kconfig                 |    1 +
> >>  drivers/mfd/max8997-irq.c           |   62 +++++++++++++++++++++--------------
> >>  drivers/mfd/max8997.c               |    1 -
> >>  include/linux/mfd/max8997-private.h |    4 ++-
> >>  include/linux/mfd/max8997.h         |    1 -
> >>  7 files changed, 41 insertions(+), 33 deletions(-)
> > 
> > Once again, this patch breaks the build.
> > 
> > Please be more careful with your patches, and TEST THEM BEFORE SENDING
> > THEM OUT.
> > 
> 
> 
> I have posted patchset including below two patch. If only first patch is
> applied to build test, this patch breaks the build. The second patch fix
> that extcon-max8997 driver use irq_domain instead of irq_base field in
> 'struct max8997_dev'.
> 
> [PATCH v3 1/2] mfd: add irq domain support for max8997 interrupts
> [PATCH v3 2/2] Extcon: MAX8997: Add support irq domain for MAX8997 muic
> 
> Please apply second patch when test this patchset.

No.  You can not break the build at any point in the patch series
process, sorry.  Each patch must be stand-alone and correct.

greg k-h
