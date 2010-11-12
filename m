Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab0KLKs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 05:48:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:45731 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756378Ab0KLKs4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 05:48:56 -0500
Subject: Re: [PATCH 2/3] perf: Add support for extra parameters for raw
 events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@elte.hu, acme@redhat.com
In-Reply-To: <AANLkTimag1+h4ujWYmWXXBspizL1+j2JtJDf+=AmWpPa@mail.gmail.com>
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
	 <1289492117-18066-2-git-send-email-andi@firstfloor.org>
	 <4CDC2DDD.50508@linux.vnet.ibm.com> <4CDC3845.4030104@linux.intel.com>
	 <4CDC4628.8020109@linux.vnet.ibm.com>
	 <20101111194936.GJ18718@basil.fritz.box> <1289505587.2084.193.camel@laptop>
	 <20101111201259.GL18718@basil.fritz.box> <1289507858.2084.195.camel@laptop>
	 <AANLkTimag1+h4ujWYmWXXBspizL1+j2JtJDf+=AmWpPa@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 12 Nov 2010 11:48:47 +0100
Message-ID: <1289558927.2084.212.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 11:41 +0100, Stephane Eranian wrote:
> > Can't remember if the load-latency msr is per-core, but its an extra reg
> > that needs to be set.
> 
> Load latency is luckily per thread. Nothing special to do to handle this one.
> We can restore its value from attr->config. 

Right, but in effect Andi adds two pieces of infrastructure, 

 - extra_reg, which determines if a particular cntr value needs extra
   data, this is useful for both the offcore msr and the pebs-ll msr.

 - per-core constraints, which is useful for shared msrs like the
   offcore and lbr config things.

So while his current patch set only uses either piece once -- to provide
offcore support -- both pieces have in fact at least one more potential
user (for future patches).


