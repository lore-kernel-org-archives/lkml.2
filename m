Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab1ISRvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 13:51:48 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:48458 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab1ISRvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 13:51:46 -0400
Date: Mon, 19 Sep 2011 23:21:29 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Paul Turner <pjt@google.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs
 unpinnede
Message-ID: <20110919175129.GA11164@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <1315922848.5977.11.camel@twins>
 <20110913162119.GA3045@linux.vnet.ibm.com>
 <1315931775.5977.29.camel@twins>
 <20110913175425.GB3062@linux.vnet.ibm.com>
 <1315937995.4226.9.camel@twins>
 <20110913182841.GO11100@linux.vnet.ibm.com>
 <1315938646.4226.12.camel@twins>
 <20110913183502.GP11100@linux.vnet.ibm.com>
 <20110915175537.GA17701@linux.vnet.ibm.com>
 <1316123323.4060.24.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1316123323.4060.24.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2011-09-15 23:48:43]:

> On Thu, 2011-09-15 at 23:25 +0530, Kamalesh Babulal wrote:
> > 2.6.38          | 1551  | 48    | 62    | 47    | 50    |
> > ----------------+-------+-------+-------+-------+-------+
> > 2.6.39          | 3784  | 457   | 722   | 3209  | 1037  | 
> 
> I'd say we wrecked it going from .38 to .39 and only made it worse after
> that.

after reverting the commit 866ab43efd325fae8889ea, of the patches 
went between .38 and .39 reduces the ping pong of the tasks.

------------------------+-------+-------+-------+-------+-------+
Kernel			| Run 1	| Run 2	| Run 3	| Run 4	| Run 5	|
------------------------+-------+-------+-------+-------+-------+
2.6.39	        	| 1542  | 2172  | 2727  | 120   | 3681  |
------------------------+-------+-------+-------+-------+-------+
2.6.39 (with    	|       |       |       |       |       |
866ab43efd reverted)	| 65	| 78	| 58	| 99 	| 62	|
------------------------+-------+-------+-------+-------+-------+
3.1-rc4+tip		|	|	|	|	|	|
(e467f18f945c)		| 1219	| 2037	| 1943	| 772	| 1701	|
------------------------+-------+-------+-------+-------+-------+
3.1-rc4+tip (e467f18f9)	|	|	|	|	|	|
(866ab43efd reverted)	| 64	| 45	| 59	| 59	| 69	|
------------------------+-------+-------+-------+-------+-------+

Thanks,
Kamalesh.
