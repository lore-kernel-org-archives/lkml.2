Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab1BGUIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 15:08:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:56774 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab1BGUIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 15:08:17 -0500
Subject: Re: [PATCH 1/2] perf_events: add cgroup support (v8)
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Menage <menage@google.com>
Cc: balbir@linux.vnet.ibm.com, eranian@google.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
In-Reply-To: <AANLkTi=+W-BXHFG94MeOnqV82HxtqtyDwEt1RCOUMrcq@mail.gmail.com>
References: <4d384700.2308e30a.70bc.ffffd532@mx.google.com>
	 <1295534345.28776.175.camel@laptop> <1296646160.26581.315.camel@laptop>
	 <20110202115012.GA16409@balbir.in.ibm.com>
	 <1296650792.26581.319.camel@laptop>
	 <AANLkTi=+W-BXHFG94MeOnqV82HxtqtyDwEt1RCOUMrcq@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Feb 2011 21:09:22 +0100
Message-ID: <1297109362.13327.56.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-07 at 11:29 -0800, Paul Menage wrote:
> > This again means that all such notification handlers must poll state,
> > which is ridiculous.
> >
> 
> Not necessarily - we could make it that a failed rmdir() sets a bit
> that causes a notification again once the final refcount is dropped
> again on the cgroup. 

But that doesn't work if you fail for any other reason than a refcount,
which you yourself proposed a while back.

Also, the core cgroup code should deal with the cgroup refcount, not
individual controllers.

