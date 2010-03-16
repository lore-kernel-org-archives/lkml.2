Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab0CPW55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 18:57:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:47314 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011Ab0CPW5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 18:57:55 -0400
Message-ID: <4BA00CE4.1090108@kernel.org>
Date: Wed, 17 Mar 2010 07:57:40 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [RFC] remove implicit slab.h inclusion from percpu.h
References: <4B990496.4020002@kernel.org> <alpine.DEB.2.00.1003161107070.2311@router.home>
In-Reply-To: <alpine.DEB.2.00.1003161107070.2311@router.home>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Mar 2010 22:57:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/17/2010 01:16 AM, Christoph Lameter wrote:
> On Thu, 11 Mar 2010, Tejun Heo wrote:
> 
>> Lee Schermerhorn was trying to use percpu from slab.h and ran into a
>> dependency loop.  percpu.h was using slab.h for UP inline
> 
> The problem is that percpu.h includes slab.h for the UP case.

Yes, that's the reason why slab.h is included in percpu.h
unconditionally.

> slab.h does not use percpu.h. Lee was trying to have topology.h use
> percpu.h which fails because percpu.h uses gfp.h which in turn uses
> topology.h again.

But apparently a lot of files depend on getting slab.h through
percpu.h and removing slab.h causes a lot of build breakages UP or
SMP.

> Did something change there or does the description need an update?

I don't find anything too wrong about the description?

Thanks.

-- 
tejun
