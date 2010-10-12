Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750854Ab0JLEHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 00:07:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60408 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab0JLEHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 00:07:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [resend][PATCH] mm: increase RECLAIM_DISTANCE to 30
Cc: kosaki.motohiro@jp.fujitsu.com, Christoph Lameter <cl@linux.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
        Rob Mueller <robm@fastmail.fm>, linux-kernel@vger.kernel.org,
        Bron Gondwana <brong@fastmail.fm>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.00.1010112004260.2066@chino.kir.corp.google.com>
References: <20101012111451.AD2E.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1010112004260.2066@chino.kir.corp.google.com>
Message-Id: <20101012130806.AD37.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 12 Oct 2010 13:07:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 12 Oct 2010, KOSAKI Motohiro wrote:
> 
> > > It doesn't determine what the maximum latency to that memory is, it relies 
> > > on whatever was defined in the SLIT; the only semantics of that distance 
> > > comes from the ACPI spec that states those distances are relative to the 
> > > local distance of 10.
> > 
> > Right. but do we need to consider fake SLIT case? I know actually such bogus
> > slit are there. but I haven't seen such fake SLIT made serious trouble.
> > 
> 
> If we can make the assumption that the SLIT entries are truly 
> representative of the latencies and are adhering to the semantics 
> presented in the ACPI spec, then this means the VM prefers to do zone 
> reclaim rather than from other nodes when the latter is 3x more costly.
> 
> That's fine by me, as I've mentioned we've done this for a couple years 
> because we've had to explicitly disable zone_reclaim_mode for such 
> configurations.  If that's the policy decision that's been made, though, 
> we _could_ measure the cost at boot and set zone_reclaim_mode depending on 
> the measured latency rather than relying on the SLIT at all in this case.

ok, got it. thanks.



