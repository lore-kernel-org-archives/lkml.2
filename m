Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab2EAPMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 11:12:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:34599 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab2EAPMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 11:12:13 -0400
Message-ID: <1335885103.13683.147.camel@twins>
Subject: Re: [RFC PATCH v1 3/5] KVM: Add paravirt kvm_flush_tlb_others
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>, mingo@elte.hu,
        jeremy@goop.org, mtosatti@redhat.com, kvm@vger.kernel.org,
        x86@kernel.org, vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Date: Tue, 01 May 2012 17:11:43 +0200
In-Reply-To: <4F9FD337.5010908@redhat.com>
References: <20120427161727.27082.43096.stgit@abhimanyu>
	   <20120427162401.27082.59387.stgit@abhimanyu>
	 <4F9D32B4.8040002@redhat.com>  <1335865176.13683.120.camel@twins>
	 <4F9FBF38.2060903@redhat.com> <1335869827.13683.133.camel@twins>
	 <4F9FD337.5010908@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-01 at 15:12 +0300, Avi Kivity wrote:
> We're now moving the freeing of kvm shadow page tables from using rcu to
> using an irq-protected scheme like gup_fast(), because of the
> performance differences.  We didn't track it down but I expect the cause
> is less reuse of cache-hot pages. 

It would be good to understand these things.. just doing things because
tends to come back and bite you :-)

If its cache behaviour you should be able to clearly see that using perf
stat.
