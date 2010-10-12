Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab0JLGlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 02:41:17 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51704 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641Ab0JLGlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 02:41:16 -0400
Date: Tue, 12 Oct 2010 12:11:08 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Mel Gorman <mel@csn.ul.ie>, Rob Mueller <robm@fastmail.fm>,
        linux-kernel@vger.kernel.org, Bron Gondwana <brong@fastmail.fm>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [resend][PATCH] mm: increase RECLAIM_DISTANCE to 30
Message-ID: <20101012064108.GE25875@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101012111451.AD2E.A69D9226@jp.fujitsu.com>
 <alpine.DEB.2.00.1010112004260.2066@chino.kir.corp.google.com>
 <20101012130806.AD37.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101012130806.AD37.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2010-10-12 13:07:35]:

> > On Tue, 12 Oct 2010, KOSAKI Motohiro wrote:
> > 
> > > > It doesn't determine what the maximum latency to that memory is, it relies 
> > > > on whatever was defined in the SLIT; the only semantics of that distance 
> > > > comes from the ACPI spec that states those distances are relative to the 
> > > > local distance of 10.
> > > 
> > > Right. but do we need to consider fake SLIT case? I know actually such bogus
> > > slit are there. but I haven't seen such fake SLIT made serious trouble.
> > > 
> > 
> > If we can make the assumption that the SLIT entries are truly 
> > representative of the latencies and are adhering to the semantics 
> > presented in the ACPI spec, then this means the VM prefers to do zone 
> > reclaim rather than from other nodes when the latter is 3x more costly.
> > 
> > That's fine by me, as I've mentioned we've done this for a couple years 
> > because we've had to explicitly disable zone_reclaim_mode for such 
> > configurations.  If that's the policy decision that's been made, though, 
> > we _could_ measure the cost at boot and set zone_reclaim_mode depending on 
> > the measured latency rather than relying on the SLIT at all in this case.
> 
> ok, got it. thanks.
>

Could we please document the change and help people understand why
with newer kernels they may see the value of zone_reclaim_mode change
on their systems and how to set it back if required. 

-- 
	Three Cheers,
	Balbir
