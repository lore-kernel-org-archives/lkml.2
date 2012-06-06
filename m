Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab2FFIk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 04:40:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:59417 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab2FFIkX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 04:40:23 -0400
Message-ID: <1338972010.2749.74.camel@twins>
Subject: RE: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Luck, Tony" <tony.luck@intel.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Wed, 06 Jun 2012 10:40:10 +0200
In-Reply-To: <alpine.LFD.2.02.1206052337300.3086@ionos>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>
	    <alpine.LFD.2.02.1206042203590.3086@ionos>
	    <1338842001.28282.135.camel@twins> <87zk8iioam.fsf@rustcorp.com.au>
	    <1338881971.28282.150.camel@twins>
	    <3E5A0FA7E9CA944F9D5414FEC6C7122007727023@ORSMSX105.amr.corp.intel.com>
	   <1338912565.2749.9.camel@twins>
	    <3E5A0FA7E9CA944F9D5414FEC6C7122007728081@ORSMSX105.amr.corp.intel.com>
	    <1338913190.2749.10.camel@twins>
	    <3908561D78D1C84285E8C5FCA982C28F19300965@ORSMSX104.amr.corp.intel.com>
	  <1338918625.2749.29.camel@twins>
	 <alpine.LFD.2.02.1206052106440.3086@ionos>
	  <1338925756.2749.36.camel@twins>
	 <alpine.LFD.2.02.1206052153200.3086@ionos> <1338931856.2749.57.camel@twins>
	 <alpine.LFD.2.02.1206052337300.3086@ionos>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 00:09 +0200, Thomas Gleixner wrote:
> We have no mechanism to exclude those cpus from general
> "oh you should do X and Y" tasks which are not really necessary at
> all. 

Its that latter part which makes this nearly impossible. How do you tell
its not really necessary?

Look at the patches Gilad did, there is very little common code between
each of those cases.

We cannot just not flush objects because the cpu is supposed to be
isolated. If it has buffer they need flushing. Not doing so would lead
to memory leaks at best and crashes at worst.

Some people want isolation to never use system calls, those are the easy
case. But the isolation case where the apps do use plenty system calls
but just don't want to deal with the perturbations of other workloads
are much harder to sort.


