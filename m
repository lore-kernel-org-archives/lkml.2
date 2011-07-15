Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684Ab1GOAv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 20:51:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:17396 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932409Ab1GOAv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 20:51:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,532,1304319600"; 
   d="scan'208";a="27867219"
Subject: Re: nohz: remove nohz_cpu_mask
From: "Alex,Shi" <alex.shi@intel.com>
To: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fu, Michael" <michael.fu@intel.com>
In-Reply-To: <20110711173047.GL2245@linux.vnet.ibm.com>
References: <1310345225.28599.10.camel@debian>
	 <20110711173047.GL2245@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 08:51:45 +0800
Message-ID: <1310691105.28599.277.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-12 at 01:30 +0800, Paul E. McKenney wrote:
> On Mon, Jul 11, 2011 at 08:47:05AM +0800, Alex,Shi wrote:
> > RCU didn't use this global variable now. Currently no user on it.
> 
> Indeed.  RCU's use of it turned out to be quite buggy.  :-(
> 
> > Since the ts->do_timer_last is not the real last periodic tick cpu in
> > most of time. I once want to compare the cpu_online_mask and
> > nohz_cpu_mask to get a real one, and than only let that cpu sleep
> > shorter, other cpu will try to sleep KTIME_MAX, that need a extra lock
> > for nohz_cpu_mask. But I checked my all platforms, from NHM-EX server to
> > laptops, all of them are waked up a few times per second. So, the
> > advantage is only in theory. 
> > 
> > Since no clear usage of this variable, why not remove it? That can save
> > a cache-line in all cpus and reduce atomic sync contention.
> 
> Works for me!
> 
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 

Thomas, would you like to give some comments of this? 

Best regards!
Alex

