Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab1CASZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 13:25:22 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36469 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab1CASZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 13:25:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=U7s/t5ZGa+1goLvHFx6xM2Z5Ht0nSz4x5iRmwvpJZ0hNbtDOAa6hFNlsPoH9D5pkIs
         44VTY46mPxr8Mhji1GyfllNtP6x4qCWfkA2pXsV1Xvbou+9ANAfgUJ29AnUT8VXqUJ0R
         Rm4UFoCKuUrZIj9F+AP0Kcb4aBPRbA4YmvtyQ=
Date: Tue, 1 Mar 2011 19:25:06 +0100
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL tip:x86/mm]
Message-ID: <20110301182506.GB23527@mtj.dyndns.org>
References: <20110224145128.GM7840@htj.dyndns.org>
 <4D66AC9C.6080500@kernel.org>
 <20110224192305.GB15498@elte.hu>
 <4D66B176.9030300@kernel.org>
 <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, David.

On Tue, Mar 01, 2011 at 09:18:45AM -0800, David Rientjes wrote:
> This is important because we want to ensure that the physical topoloy of 
> the machine is still represented in an emulated environment to 
> appropriately describe the expected latencies between the nodes.  It also 
> allows users who are using numa=fake purely as a debugging tool to test 
> more interesting configurations and benchmark memory accesses between 
> emulated nodes as though they were real.

Sure, definitely.

> 	10 20 20 30 10 20 20 30 10 20 20 30 10 20 20 30
> 	20 20 10 20 20 20 10 20 20 20 10 20 20 20 10 20
> 	30 20 20 10 30 20 20 10 30 20 20 10 30 20 20 10
> 	10 20 20 30 10 20 20 30 10 20 20 30 10 20 20 30
> 	20 10 20 20 20 10 20 20 20 10 20 20 20 10 20 20
> 	20 20 10 20 20 20 10 20 20 20 10 20 20 20 10 20
> 	30 20 20 10 30 20 20 10 30 20 20 10 30 20 20 10
> 	20 10 20 20 20 10 20 20 20 10 20 20 20 10 20 20
> 	20 20 10 20 20 20 10 20 20 20 10 20 20 20 10 20
> 	30 20 20 10 30 20 20 10 30 20 20 10 30 20 20 10
> 	10 20 20 30 10 20 20 30 10 20 20 30 10 20 20 30
> 	20 10 20 20 20 10 20 20 20 10 20 20 20 10 20 20
> 	20 20 10 20 20 20 10 20 20 20 10 20 20 20 10 20
> 	30 20 20 10 30 20 20 10 30 20 20 10 30 20 20 10
> 	10 20 20 30 10 20 20 30 10 20 20 30 10 20 20 30
> 	20 10 20 20 20 10 20 20 20 10 20 20 20 10 20 20
> 
> (And that is what we see with 2.6.37.)

And this should have been the result.  I've actually tested with fake
original distance table including asymmetric distances.

> However, x86/mm describes these distances differently:
> 
> 	node0/distance:10 20 20 20 10 20 20 20 10 20 20 20 10 20 20 20
> 	node1/distance:10 10 20 20 10 20 20 20 10 20 20 20 10 20 20 20
> 	node2/distance:10 20 10 20 10 20 20 20 10 20 20 20 10 20 20 20
> 	node3/distance:10 20 20 10 10 20 20 20 10 20 20 20 10 20 20 20
> 	node4/distance:10 20 20 20 10 20 20 20 10 20 20 20 10 20 20 20
> 	node5/distance:10 20 20 20 10 10 20 20 10 20 20 20 10 20 20 20
> 	node6/distance:10 20 20 20 10 20 10 20 10 20 20 20 10 20 20 20
> 	node7/distance:10 20 20 20 10 20 20 10 10 20 20 20 10 20 20 20
> 	node8/distance:10 20 20 20 10 20 20 20 10 20 20 20 10 20 20 20
> 	node9/distance:10 20 20 20 10 20 20 20 10 10 20 20 10 20 20 20
> 	node10/distance:10 20 20 20 10 20 20 20 10 20 10 20 10 20 20 20
> 	node11/distance:10 20 20 20 10 20 20 20 10 20 20 10 10 20 20 20
> 	node12/distance:10 20 20 20 10 20 20 20 10 20 20 20 10 20 20 20
> 	node13/distance:10 20 20 20 10 20 20 20 10 20 20 20 10 10 20 20
> 	node14/distance:10 20 20 20 10 20 20 20 10 20 20 20 10 20 10 20
> 	node15/distance:10 20 20 20 10 20 20 20 10 20 20 20 10 20 20 10
> 
> It looks as though the emulation changes sitting in x86/mm have dropped 
> the SLIT and are merely describing the emulated nodes as either having 
> physical affinity or not.

It looks like I missed something.  I'll look into it first thing
tomorrow.  If you feel like looking into where it's going wrong,
please go ahead.  BTW, how did you insert the custom SLIT table?  If
it's some ACPI trick I can use here, do you care to share?

Thanks.

-- 
tejun
