Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab2EAWty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 18:49:54 -0400
Received: from claw.goop.org ([74.207.240.146]:40954 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936Ab2EAWtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 18:49:52 -0400
Message-ID: <4FA0688E.8030200@goop.org>
Date: Tue, 01 May 2012 15:49:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>, mingo@elte.hu,
        mtosatti@redhat.com, kvm@vger.kernel.org, x86@kernel.org,
        vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [RFC PATCH v1 3/5] KVM: Add paravirt kvm_flush_tlb_others
References: <20120427161727.27082.43096.stgit@abhimanyu>  <20120427162401.27082.59387.stgit@abhimanyu> <4F9D32B4.8040002@redhat.com>  <1335865176.13683.120.camel@twins> <4F9FBF38.2060903@redhat.com>  <1335869827.13683.133.camel@twins> <1335869998.13683.135.camel@twins>
In-Reply-To: <1335869998.13683.135.camel@twins>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2012 03:59 AM, Peter Zijlstra wrote:
> On Tue, 2012-05-01 at 12:57 +0200, Peter Zijlstra wrote:
>> Anyway, I don't have any idea about the costs involved with
>> HAVE_RCU_TABLE_FREE, but I don't think its much.. otherwise these other
>> platforms (PPC,SPARC) wouldn't have used it, gup_fast() is a very
>> specific case, whereas mmu-gather is something affecting pretty much all
>> tasks. 
> Which reminds me, I thought Xen needed this too, but a git grep on
> HAVE_RCU_TABLE_FREE shows its still only ppc and sparc.
>
> Jeremy?

Yeah, I was thinking that too, but I can't remember what we did to
resolve it.  For pure PV guests, gupf simply isn't used, so the problem
is moot.  But for dom0 or PCI-passthrough it could be.

Konrad, Stefano?

    J
