Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab1GHPSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 11:18:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:49717 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab1GHPSq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 11:18:46 -0400
Subject: Re: [PATCH 1/4] perf: Add memory load/store events generic code
From: Peter Zijlstra <peterz@infradead.org>
To: Anton Blanchard <anton@samba.org>
Cc: Paul Mackerras <paulus@samba.org>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20110708171836.6465a12e@kryten>
References: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
	 <1309766525-14089-2-git-send-email-ming.m.lin@intel.com>
	 <1309768420.3282.8.camel@twins> <1309769066.3282.14.camel@twins>
	 <1309867418.3282.73.camel@twins>
	 <20110705230217.GA9584@bloggs.ozlabs.ibm.com>
	 <1309960718.3282.289.camel@twins>  <20110708171836.6465a12e@kryten>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 08 Jul 2011 17:18:28 +0200
Message-ID: <1310138308.3282.708.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-08 at 17:18 +1000, Anton Blanchard wrote:
> Hi Peter,
> 
> > The thing we're talking about is Intel PEBS Load Latency/Precise Store
> > and AMD IBS where together with a mem op retired event (mem loads
> > retired for Load-Latency, mem stores retired for Precise Store)
> > provides an additional field describing where the load/store was
> > sourced from.
> > 
> > Such additional data would require the addition of a
> > PERF_SAMPLE_SOURCE field or similar, for some reason or other I was
> > under the impression some of the PPC chips had something similar. But
> > if not, it saves us having to worry about that.
> 
> It does sound a lot like our event vector, where we can have up to
> 64 bits of information that goes with a sample. A lot of the fields
> relate to loads and stores, but there are other fields (eg pipeline
> information at the point the sample was taken).
> 
> So we could definitely use a field to capture this.

Happen to have a ref to some docs about that? We'd want to make sure our
definition is wide enough to also work for ppc.
