Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab3ACXEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 18:04:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:55380 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770Ab3ACXEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 18:04:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,405,1355126400"; 
   d="scan'208";a="241818907"
Date: Thu, 3 Jan 2013 07:03:48 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>, Rob Landley <rob@landley.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH v4 3/3] PM: Introduce Intel PowerClamp Driver
Message-ID: <20130103070348.59b89cf7@jacob-desktop>
In-Reply-To: <1357241654.5452.16.camel@joe-AO722>
References: <1357210875-5025-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1357210875-5025-4-git-send-email-jacob.jun.pan@linux.intel.com>
	<1357241654.5452.16.camel@joe-AO722>
Organization: OTC
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Jan 2013 11:34:14 -0800
Joe Perches <joe@perches.com> wrote:

> On Thu, 2013-01-03 at 03:01 -0800, Jacob Pan wrote:
> > Intel PowerClamp driver performs synchronized idle injection across
> > all online CPUs. The goal is to maintain a given package level
> > C-state ratio.
> 
> just trivia:
> 
> > diff --git a/drivers/thermal/intel_powerclamp.c
> > b/drivers/thermal/intel_powerclamp.c
> 
> > +static int clamping;
> 
> bool and use true/false?
sure. will change in v5
> 
> > +static int window_size_set(const char *arg, const struct
> > kernel_param *kp)
> []
> > +	if (new_window_size >= 10 || new_window_size < 2) {
> > +		pr_err("Invalid window size %lu, between 2-10\n",
> > +			new_window_size);
> 
> This is a misleading message or a bad test,
> It's from 2 to 9
> 
> This would more normally be tested/written as
> 
> 	val < low || val > high
> 
will change to make the range match error message, between 2 to 10.

Thanks,

Jacob
