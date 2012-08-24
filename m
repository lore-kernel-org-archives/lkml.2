Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab2HXHIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 03:08:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:59689 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175Ab2HXHIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 03:08:17 -0400
Message-ID: <1345792051.29170.25.camel@pasglop>
Subject: Re: [PATCH v4 2/2] powerpc: Uprobes port to powerpc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: ananth@in.ibm.com, ppcdev <linuxppc-dev@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@samba.org>, peterz@infradead.org,
        oleg@redhat.com, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>
Date: Fri, 24 Aug 2012 17:07:31 +1000
In-Reply-To: <1345770803.13865.10.camel@concordia>
References: <20120822082205.GA29216@in.ibm.com>
	 <20120822082708.GB29216@in.ibm.com> <1345696100.3338.21.camel@concordia>
	 <20120823055820.GA14603@in.ibm.com> <1345770803.13865.10.camel@concordia>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-24 at 11:13 +1000, Michael Ellerman wrote:
> 
> Yeah. A NULL regs here is a kernel bug, so I think it's actually
> preferable to crash than silently return. 

Or best, if you think there's a remote chance that the bug might hit:

	if (WARN(!regs))
		return

Cheers,
Ben.


