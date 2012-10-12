Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005Ab2JLS1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 14:27:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759728Ab2JLS1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 14:27:07 -0400
Message-ID: <507860F5.7090908@redhat.com>
Date: Fri, 12 Oct 2012 14:27:01 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: John Stultz <johnstul@us.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RCU NOHZ, tsc, and clock_gettime
References: <5077157A.7060401@redhat.com> <50772350.1070903@us.ibm.com> <20121011202103.GB2476@linux.vnet.ibm.com>
In-Reply-To: <20121011202103.GB2476@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The effect of removing the two functions you noted (on 3.6 and earlier)
> is to prevent RCU from checking for dyntick-idle CPUs, likely incurring
> a cache miss for each CPU with interrupts disabled.  If you have a lot
> of CPUs (or even if NR_CPUS is large and you have a smaller number of
> CPUs), this can result in user-space-visible delays.
> 

Paul,

I built a kernel with NR_CPUS=48 and booted on a 48 cpu (logical) system.  I do
not see a difference in the test -- the variance is AFAICT just as large as if I
had run with NR_CPUS=4096.

P.
