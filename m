Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab0JLDMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 23:12:35 -0400
Received: from smtp-out.google.com ([74.125.121.35]:19742 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab0JLDMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 23:12:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=SKKgjNfIadKREIjI2CLBYw/q0EQ+HNpieOR+24KDyAqj7dRrDTBqVGyy5JuIiw2ApB
         L0p95XXJjg2aP/XgZjMw==
Date: Mon, 11 Oct 2010 20:12:26 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Christoph Lameter <cl@linux.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
        Mel Gorman <mel@csn.ul.ie>, Rob Mueller <robm@fastmail.fm>,
        linux-kernel@vger.kernel.org, Bron Gondwana <brong@fastmail.fm>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [resend][PATCH] mm: increase RECLAIM_DISTANCE to 30
In-Reply-To: <20101012111451.AD2E.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1010112004260.2066@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1010081255010.32749@router.home> <alpine.DEB.2.00.1010111907190.27825@chino.kir.corp.google.com> <20101012111451.AD2E.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Oct 2010, KOSAKI Motohiro wrote:

> > It doesn't determine what the maximum latency to that memory is, it relies 
> > on whatever was defined in the SLIT; the only semantics of that distance 
> > comes from the ACPI spec that states those distances are relative to the 
> > local distance of 10.
> 
> Right. but do we need to consider fake SLIT case? I know actually such bogus
> slit are there. but I haven't seen such fake SLIT made serious trouble.
> 

If we can make the assumption that the SLIT entries are truly 
representative of the latencies and are adhering to the semantics 
presented in the ACPI spec, then this means the VM prefers to do zone 
reclaim rather than from other nodes when the latter is 3x more costly.

That's fine by me, as I've mentioned we've done this for a couple years 
because we've had to explicitly disable zone_reclaim_mode for such 
configurations.  If that's the policy decision that's been made, though, 
we _could_ measure the cost at boot and set zone_reclaim_mode depending on 
the measured latency rather than relying on the SLIT at all in this case.
