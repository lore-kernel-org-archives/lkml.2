Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab2KNBYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 20:24:53 -0500
Received: from mga03.intel.com ([143.182.124.21]:12231 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932345Ab2KNBYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 20:24:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,247,1352102400"; 
   d="scan'208";a="217394567"
Date: Tue, 13 Nov 2012 17:24:49 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: paulmck@linux.vnet.ibm.com
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH 3/3] PM: Introduce Intel PowerClamp Driver
Message-ID: <20121113172449.0f7b1754@chromoly>
In-Reply-To: <20121114000259.GK2489@linux.vnet.ibm.com>
References: <1352757831-5202-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1352757831-5202-4-git-send-email-jacob.jun.pan@linux.intel.com>
	<20121113211602.GA30150@linux.vnet.ibm.com>
	<20121113133922.47144a50@chromoly>
	<20121113222350.GH2489@linux.vnet.ibm.com>
	<50A2CD77.7000403@linux.intel.com>
	<20121114000259.GK2489@linux.vnet.ibm.com>
Organization: OTC
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2012 16:03:00 -0800
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> Just to make sure I am really understanding what is happening, let's
> suppose we have a HZ=1000 system that has a few tasks that
> occasionally run at prio 99.  These tasks would run during the clamp
> interval, but would (for example) see the jiffies counter remaining
> at the value at the beginning of the clamp interval until the end of
> that interval, when the jiffies counter would suddenly jump by roughly
> six counts, right?

Yes, if there is no interrupts disturb the clamping duration.
We do not mask interrupts which will update jiffies.

-- 
Thanks,

Jacob
