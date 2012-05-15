Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966914Ab2EOVNv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 17:13:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:60064 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966814Ab2EOVNt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 17:13:49 -0400
Message-ID: <1337116407.27694.118.camel@twins>
Subject: Re: [PATCH v3 5/5] cpusets, suspend: Save and restore cpusets
 during suspend/resume
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Rientjes <rientjes@google.com>
Cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        mingo@kernel.org, pjt@google.com, paul@paulmenage.org,
        akpm@linux-foundation.org, rjw@sisk.pl, nacc@us.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, tj@kernel.org, mschmidt@redhat.com,
        berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Date: Tue, 15 May 2012 23:13:27 +0200
In-Reply-To: <alpine.DEB.2.00.1205151346570.1656@chino.kir.corp.google.com>
References: <20120513231325.3566.37740.stgit@srivatsabhat>
	 <20120513231710.3566.45349.stgit@srivatsabhat>
	 <alpine.DEB.2.00.1205141735050.25235@chino.kir.corp.google.com>
	 <20120515014042.GA9774@linux.vnet.ibm.com>
	 <alpine.DEB.2.00.1205142055160.10906@chino.kir.corp.google.com>
	 <20120515044539.GA25256@linux.vnet.ibm.com>
	 <alpine.DEB.2.00.1205151106490.24304@chino.kir.corp.google.com>
	 <1337112653.27694.110.camel@twins>
	 <alpine.DEB.2.00.1205151346570.1656@chino.kir.corp.google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 14:05 -0700, David Rientjes wrote:
> Not sure what you're disagreeing with, it only happens with 
> MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES and I've clearly defined the 
> behavior in the man page.  I personally never had a use-case for 
> MPOL_F_RELATIVE_NODES but Paul Jackson asked that it be added for SGI when 
> we added mempolicy mode flags. 

So what you're saying is that:

task t: set_mempolicy(,mask=2-3);

add t to cpuset A

A.mems = 0-1
A.mems = 0-n

At which point t will again have 2-3, right?

My objection is that you'll have to keep the 2-3 mask around some place
because t->mems_allowed will be wrecked by cpuset actions.

Also, what does it mean to silently return to 2-3 after you've broken
that promise by forcing it to 0-1 using cpusets?


