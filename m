Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab2EUC32 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 22:29:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59060 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab2EUC31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 22:29:27 -0400
Date: Sun, 20 May 2012 19:29:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: broonie@opensource.wolfsonmicro.com, thomas.abraham@linaro.org,
        grant.likely@secretlab.ca, sameo@linux.intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mfd: add irq domain support for max8997 interrupts
Message-ID: <20120521022921.GA13084@kroah.com>
References: <1337154104-22036-1-git-send-email-cw00.choi@samsung.com>
 <20120518235916.GA14015@kroah.com>
 <4FB97E22.7090604@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FB97E22.7090604@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 08:28:34AM +0900, Chanwoo Choi wrote:
> Hi Greg,
> 
> On 05/19/2012 08:59 AM, Greg KH wrote:
> 
> > On Wed, May 16, 2012 at 04:41:44PM +0900, Chanwoo Choi wrote:
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
> >> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> >> 	[Fix two bug which set max8997->irq_domain and correct wrong parameter]
> >> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > 
> > Same problem as before, I apply this and it breaks the build with the
> > following errors:
> > 
> > drivers/extcon/extcon-max8997.c: In function ‘max8997_muic_irq_work’:
> > drivers/extcon/extcon-max8997.c:350:36: error: ‘struct max8997_dev’ has no member named ‘irq_base’
> > drivers/extcon/extcon-max8997.c: In function ‘max8997_muic_probe’:
> > drivers/extcon/extcon-max8997.c:452:35: error: ‘struct max8997_platform_data’ has no member named ‘irq_base’
> > drivers/extcon/extcon-max8997.c: In function ‘max8997_muic_remove’:
> > drivers/extcon/extcon-max8997.c:514:19: error: ‘struct max8997_dev’ has no member named ‘irq_base’
> > 
> > Please fix.
> 
> I posted patchset including below two patch. The second patch fix that
> extcon-max8997 driver use irq_domain instead of irq_base field in
> 'struct max8997_dev'.
> 
> Please apply second patch when test this patchset.

No, you can not break the build at any point in the patch process,
sorry.

Please resend these so the build does not break, but note, you have
missed the merge window for 3.5, as 3.4 is now out (well, will be in a
few hours once kernel.org comes back from the dead...)

So you will have to wait for 3.5-rc1 to be released before I can apply
it.

thanks,

greg k-h
