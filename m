Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab1KGSaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 13:30:25 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:4564 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab1KGSaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 13:30:24 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz936eK1432N98dKzz1202hzzz2dh87h2a8h668h839h8e2h8e3h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:160.36.179.132;KIP:(null);UIP:(null);IPV:NLI;H:kedge1.utk.tennessee.edu;RD:kedge1.utk.tennessee.edu;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 7 Nov 2011 13:30:11 -0500
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [perf] enable raw OFFCORE_EVENTS for non-perf userspace
In-Reply-To: <1312473330.16729.42.camel@twins>
Message-ID: <alpine.DEB.2.00.1111071327380.12695@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1108031200390.703@cl320.eecs.utk.edu> <1312473330.16729.42.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Aug 2011, Peter Zijlstra wrote:

> On Wed, 2011-08-03 at 12:05 -0400, Vince Weaver wrote:
> > Hello
> > 
> > I propose we just enable raw OFFCORE_EVENT support and get it over with.
> > 
> > There is a lot of demand for this from PAPI users, and so we encourage 
> > them to apply the below patch.  PAPI supports this out of the box.
> > 
> > The current "block" against using this feature *DOES NOT WORK*.
> > It silently fails if you try to use the config1 field to set it.
> > 
> > Even worse, if some previous user has set the OFFCORE_RSP_0 msr
> > (say by running "perf stat -e LLC-load-misses") then
> > the msr *stays set* and if you try to set the config1 field on your own
> > it looks like it worked, but instead it is using whatever value the
> > kernel last used.
> > 
> > So there's a lot of userspace confusion about this, and you can't even 
> > reliably tell if the feature is turned off or not because it fails 
> > silently in unpredictable ways.

Is there any hope for either the patch that enables raw offcore_response, 
or the other patch that properly disables it?

Currently as mentioned the OFFCORE_RSP_0 msr value is leaked if a 
generalized event is using offcore response, thus it is not possible to 
properly detect availability of raw offcore response.

Since this MSR leakage has been in at least two released kernels now, it's
tempting to assume it's the published ABI and start hacking up PAPI so 
it can use it as a backdoor to enable RAW offcore response without needing 
the kernel patches.

Vince

