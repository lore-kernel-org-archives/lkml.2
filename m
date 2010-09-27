Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509Ab0I0Ol2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 10:41:28 -0400
Received: from imr4.ericy.com ([198.24.6.8]:33600 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759318Ab0I0OlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 10:41:18 -0400
Date: Mon, 27 Sep 2010 07:40:08 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH v2] hwmon (coretemp): Fix build breakage if SMP is
 undefined
Message-ID: <20100927144008.GA2577@ericsson.com>
References: <1285588796-20956-1-git-send-email-guenter.roeck@ericsson.com>
 <20100927125946.GB2862@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100927125946.GB2862@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 08:59:46AM -0400, Ingo Molnar wrote:
> 
> * Guenter Roeck <guenter.roeck@ericsson.com> wrote:
> 
> > +#ifdef CONFIG_SMP
> > +#endif
> > +#ifdef CONFIG_SMP
> > +#endif
> 
> Hm, this tickles my uglo-meter. Is there no cleaner way, preferably one 
> that doesnt involve preprocessor directives?
> 
After looking through the code I thought about a much cleaner fix for
handling the SMP defines in coretemp.c and pkgtemp.c. Essentially
it will move all SMP dependencies into a single #ifdef, and also
optimize the loop in question with cpumask_first() / cpumask_next().
Maybe I can get rid of some of the SMP dependencies entirely. However,
the driver also uses phys_proc_id and cpu_core_id from cpuinfo_x86,
and those are only available if SMP is defined.

That would be way too invasive for .36, though. I'll stick with the
current patch and submit a cleanup for .37. That also fits well with
the other pending cleanups for the two drivers.

Thanks,
Guenter

