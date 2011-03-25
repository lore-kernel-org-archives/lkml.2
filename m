Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab1CYOnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:43:23 -0400
Received: from claw.goop.org ([74.207.240.146]:44451 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610Ab1CYOnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:43:22 -0400
Message-ID: <4D8CAA02.2020403@goop.org>
Date: Fri, 25 Mar 2011 14:43:14 +0000
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, venki@google.com,
        ak@linux.intel.com, suresh.b.siddha@intel.com, sfr@canb.auug.org.au,
        peterz@infradead.org, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        arjan@linux.intel.com, Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: Re: [Xen-devel] Re: [RFC PATCH V4 4/5] cpuidle: driver for xen
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>	<20110322123324.28725.3131.stgit@tringupt.in.ibm.com>	<20110322145054.GB26952@dumpdata.com>	<4D89C40B.4020809@linux.vnet.ibm.com>	<alpine.LFD.2.02.1103231659210.12911@x980>	<20110324120522.GB29294@dumpdata.com> <alpine.LFD.2.02.1103250315180.32565@x980>
In-Reply-To: <alpine.LFD.2.02.1103250315180.32565@x980>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2011 07:19 AM, Len Brown wrote:
> The Xen Dom0 kernel will trap into the hypervisor
> whenever it does a HLT or an MWAIT, yes?

Yes, on hlt.

> What is the benefit of having Dom0 decided between
> C-states that it can't actually enter?

There might be a slight benefit to allow a domain to tell Xen what its
overall utilisation is (ie, "I'd like this VCPU to run, but it isn't
very important so you can take that into account when choosing
scheduling priority and/or PCPU performance").  But there's nothing like
that at present.

> What is the mechanism by which those C-states are
> made visible to Dom0, and how are those states
> related to the states that are supported on
> the bare iron?

Because dom0 is the official ACPI owner (ie, it has the AML
interpreter), we need dom0 to handle complex interactions with ACPI (the
hypervisor can do simple table parsing).  At present the mechanism for
power states is that dom0 gets them out of ACPI, and then passes them to
Xen which actually uses them.  But no guest kernel has any runtime use
of power states.

    J
