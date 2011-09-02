Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab1IBN0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 09:26:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:51978 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab1IBN0W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 09:26:22 -0400
Subject: Re: [PATCH -mm 1/2] irq_work, Use llist in irq_work
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 02 Sep 2011 15:26:12 +0200
In-Reply-To: <4E602EC8.9010306@intel.com>
References: <1314681384-20881-1-git-send-email-ying.huang@intel.com>
				 <1314681384-20881-2-git-send-email-ying.huang@intel.com>
			 <1314785405.23993.21.camel@twins> <4E5EE409.3060102@intel.com>
		 <1314863829.7945.9.camel@twins> <4E5F45F6.70009@intel.com>
	 <1314871201.7945.17.camel@twins> <4E602EC8.9010306@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314969972.1301.15.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-02 at 09:18 +0800, Huang Ying wrote:
> On 09/01/2011 06:00 PM, Peter Zijlstra wrote:
> > On Thu, 2011-09-01 at 16:44 +0800, Huang Ying wrote:
> > 
> >> Because llist is in library, it may be used in highly contended case and
> >> light/un-contended loads.  So maybe code as above is best choice for llist.
> > 
> > Well the thing is, if you're heavily contended you should probably be
> > doing something else..
> 
> So which solution is preferable?
> 
> 1) no cpu_relax
> 2) cpu_relax after first cmpxchg
> 
> Personally, I prefer 2).  It should have acceptable overhead in
> ligh/un-contended loads.  Do you agree.

I guess so, we can always poke at it again when someone finds something
to measure.
