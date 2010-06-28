Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284Ab0F1Jbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 05:31:41 -0400
Received: from ozlabs.org ([203.10.76.45]:33972 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab0F1Jbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 05:31:39 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 2/5] cpumask: make task_struct.cpus_allowed a cpumask_var_t
Date: Mon, 28 Jun 2010 19:01:26 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>, Bryan Wu <cooloney@kernel.org>,
       Tony Luck <tony.luck@intel.com>, Ralf Baechle <ralf@linux-mips.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
       anton@samba.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mike Travis <travis@sgi.com>
References: <201006252233.40481.rusty@rustcorp.com.au> <alpine.DEB.2.00.1006251058180.18900@router.home>
In-Reply-To: <alpine.DEB.2.00.1006251058180.18900@router.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006281901.27517.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jun 2010 01:30:25 am Christoph Lameter wrote:
> On Fri, 25 Jun 2010, Rusty Russell wrote:
> 
> > Even better would be to point to the fixed "one cpu" and "all cpus"
> > masks where possible, and make a copy when setting it to something
> > else.  But you'd have to track down those naughty places which frob it
> > directly...
> 
> Put it into a read only segment?

Well, I was thinking of an audit as the first step :)

> What is the estimated performance impact of adding a level of indirection
> (and a potential cache miss) to a number of critical code paths?

Unknown.  Originally, I moved the mask to the end of the struct (so we could
under-allocate for the CPUMASK_OFFSTACK nr_cpu_ids < NR_CPUS case), but Ingo
didn't want to change the struct for the non-CPUMASK_OFFSTACK case.

Measurements welcome...
Rusty.
