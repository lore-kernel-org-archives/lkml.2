Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab2FFIYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 04:24:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38494 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab2FFIYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 04:24:07 -0400
Message-ID: <1338971020.2749.64.camel@twins>
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
Date: Wed, 06 Jun 2012 10:23:40 +0200
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
> > Well, no not like that, but I think we could do with some coupling
> > there. Like steer active interrupts away when they keep hitting idle
> > state.
> 
> That's possible, but that wants a well coordinated mechanism which
> takes the user space steering into account.

Sure, if the provided interrupt affinity mask doesn't allow this, we
loose. But typically those are all bits set.

> I'm not saying it's impossible, I'm just trying to imagine the extra
> user space interfaces needed for that. 

None, preferably.
