Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761243Ab0FRNNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 09:13:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:41635 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760958Ab0FRNNH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 09:13:07 -0400
Subject: Re: [RFC 1/3] Unified NMI delayed call mechanism
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H.PeterA" <"nvin hpa"@zytor.com>, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>
In-Reply-To: <20100618130921.GC9045@basil.fritz.box>
References: <1276334896-7075-1-git-send-email-ying.huang@intel.com>
	 <1276862130.1875.7.camel@laptop> <20100618122532.GB9045@basil.fritz.box>
	 <1276865304.1875.12.camel@laptop>  <20100618130921.GC9045@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 18 Jun 2010 15:12:49 +0200
Message-ID: <1276866769.1875.14.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-18 at 15:09 +0200, Andi Kleen wrote:
> > You generally want to pass more information along anyway, now your
> > callback function needs to go look for it. Much better to pass a
> > work_struct like thing around that is contained in the state it needs.
> 
> But how would you allocate the work queue in an NMI?
> 
> If it's only a single instance (like this bit) it can be always put
> into a per cpu variable.

Pre-allocate. For the perf-event stuff we use the perf_event allocated
at creation time. But yeah, per-cpu storage also works.
