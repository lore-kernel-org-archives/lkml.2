Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab0KMTiq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 14:38:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:39235 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab0KMTio convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 14:38:44 -0500
Subject: Re: [RFC][PATCH v2 4/7] taskstats: Add per task steal time
 accounting
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>, John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
In-Reply-To: <20101111170815.024542355@linux.vnet.ibm.com>
References: <20101111170352.732381138@linux.vnet.ibm.com>
	 <20101111170815.024542355@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 13 Nov 2010 20:38:02 +0100
Message-ID: <1289677083.2109.167.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 18:03 +0100, Michael Holzheu wrote:
> From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> 
> Currently steal time is only accounted for the whole system. With this
> patch we add steal time to the per task CPU time accounting.
> The triplet "user time", "system time" and "steal time" represents
> all consumed CPU time on hypervisor based systems. 

Does that really make sense? Its not like the hypervisor really knows
anything about tasks and won't steal from one? Its really a vcpu
feature.

What added benefit will all this extra accounting give?
