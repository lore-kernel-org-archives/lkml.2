Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab1ILKSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 06:18:05 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:36221 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab1ILKSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 06:18:02 -0400
Date: Mon, 12 Sep 2011 15:47:22 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs
 unpinnede
Message-ID: <20110912101722.GA28950@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20110608163234.GA23031@linux.vnet.ibm.com>
 <BANLkTim7a9uhH_K6sw4YdqWB6frT+HUqqQ@mail.gmail.com>
 <20110610181719.GA30330@linux.vnet.ibm.com>
 <BANLkTimE1b8HP-q4jgsv5jPD5S-dRoUi_g@mail.gmail.com>
 <20110615053716.GA390@linux.vnet.ibm.com>
 <BANLkTi=7S2qdVjbJkDja+GAoD=pNo2gPsTFZMFkB8NWWkO1JVQ@mail.gmail.com>
 <20110907152009.GA3868@linux.vnet.ibm.com>
 <1315423342.11101.25.camel@twins>
 <20110908151433.GB6587@linux.vnet.ibm.com>
 <1315571462.26517.9.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1315571462.26517.9.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11091210-7282-0000-0000-000001627D23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2011-09-09 14:31:02]:

> > Machine : 16-cpus (2 Quad-core w/ HT enabled)
> > Cgroups : 5 in number (C1-C5), each having {2, 2, 4, 8, 16} tasks respectively.
> >           Further, each task is placed in its own (sub-)cgroup with 
> >           a capped usage of 50% CPU.
> 
> So that's loads: {512,512}, {512,512}, {256,256,256,256}, {128,..} and {64,..}

Yes, with the default shares of 1024 for each cgroup.

FWIW we did also try setting shares for each cgroup proportional to number of 
tasks it has. For ex: C1's shares = 1024 * 2 = 2048, C2 = 1024 * 2 = 2048, 
C3 = 4 * 1024 = 4096 etc. while /C1/C1_1, /C1/C1_2, .../C5/C5_16/ shares were 
left at default of 1024 (as those sub-cgroups contain only one task). 
 
That does help reduce idle time by almost 50% (from 15-20% -> 6-9%)

- vatsa

