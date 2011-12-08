Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408Ab1LHQNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 11:13:19 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:5080 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab1LHQNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 11:13:18 -0500
Date: Thu, 8 Dec 2011 17:13:03 +0100
From: Jean Delvare <khali@linux-fr.org>
To: guenter.roeck@ericsson.com
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>, trenn@suse.de,
        Andi Kleen <ak@linux.intel.com>, fenghua.yu@intel.com
Subject: Re: [PATCH 06/10] HWMON: Convert coretemp to x86 cpuid autoprobing
Message-ID: <20111208171303.796aa673@endymion.delvare>
In-Reply-To: <1323360569.2415.16.camel@groeck-laptop>
References: <1323304882-27953-1-git-send-email-andi@firstfloor.org>
	<1323304882-27953-7-git-send-email-andi@firstfloor.org>
	<20111208024001.GA4912@ericsson.com>
	<20111208082402.3591123f@endymion.delvare>
	<1323360569.2415.16.camel@groeck-laptop>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Dec 2011 08:09:29 -0800, Guenter Roeck wrote:
> On Thu, 2011-12-08 at 02:24 -0500, Jean Delvare wrote:
> > Hi Andi,
> > 
> > Thanks a lot for working on this. I wanted to give it a try long ago but
> > could never find the time.
> > 
> > On Wed, 7 Dec 2011 18:40:01 -0800, Guenter Roeck wrote:
> > > Andi,
> > > 
> > > On Wed, Dec 07, 2011 at 07:41:19PM -0500, Andi Kleen wrote:
> > > > From: Andi Kleen <ak@linux.intel.com>
> > > > 
> > > > Use the new x86 cpuid autoprobe interface for the Intel coretemp
> > > > driver.
> > > > 
> > > > Cc: fenghua.yu@intel.com
> > > > Cc: khali@linux-fr.org
> > > > Cc: guenter.roeck@ericsson.com
> > > > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > > > ---
> > > >  drivers/hwmon/coretemp.c |   17 ++++++++++++++---
> > > >  1 files changed, 14 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> > > > index 104b376..5de1579 100644
> > > > --- a/drivers/hwmon/coretemp.c
> > > > +++ b/drivers/hwmon/coretemp.c
> > > > @@ -39,6 +39,7 @@
> > > >  #include <linux/moduleparam.h>
> > > >  #include <asm/msr.h>
> > > >  #include <asm/processor.h>
> > > > +#include <asm/cpu_device_id.h>
> > > >  
> > > >  #define DRVNAME	"coretemp"
> > > >  
> > > > @@ -756,13 +757,23 @@ static struct notifier_block coretemp_cpu_notifier __refdata = {
> > > >  	.notifier_call = coretemp_cpu_callback,
> > > >  };
> > > >  
> > > > +static struct x86_cpu_id coretemp_ids[] = {
> > 
> > Can't this be made const?
> > 
> Unless I am missing something, the patchset would have to change to
> accept a const as parameter to x86_match_cpu().

Yes, I proposed that too in my review of the relevant patch.

-- 
Jean Delvare
