Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab1ATJv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 04:51:58 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:43050 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab1ATJvz convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:13:1>);
	Thu, 20 Jan 2011 04:51:55 -0500
Message-Id: <4D3813E5020000780002D5FA@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 20 Jan 2011 09:52:21 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
        "Eric Dumazet" <dada1@cosmosbay.com>, <xiyou.wangcong@gmail.com>,
        <suzuki@in.ibm.com>, "Peter Zijlstra" <peterz@infradead.org>,
        "Nick Piggin" <npiggin@kernel.dk>, <vatsa@linux.vnet.ibm.com>,
        "Linux Virtualization" <virtualization@lists.linux-foundation.org>,
        "Xen-devel" <xen-devel@lists.xensource.com>,
        "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
        "Avi Kivity" <avi@redhat.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 13/14] x86/ticketlock: add slowpath logic
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
 <97ed99ae9160bdb6477284b333bd6708fb7a19cb.1289940821.git.jeremy.fitzhardinge@citrix.com>
 <20110117152222.GA19233@linux.vnet.ibm.com> <4D372DEA.1060004@goop.org>
 <20110119183914.GB7235@linux.vnet.ibm.com> <4D37338E.8030509@goop.org>
In-Reply-To: <4D37338E.8030509@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 19.01.11 at 19:55, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> On 01/19/2011 10:39 AM, Srivatsa Vaddagiri wrote:
>> I have tested quite extensively with booting a 16-vcpu guest (on a 16-pcpu 
> host)
>> and running kernel compine (with 32-threads). Without this patch, I had
>> difficulty booting/shutting-down successfully (it would hang mid-way).
> 
> Sounds good.  But I like to test with "make -j 100-200" to really give
> things a workout.

Hmm, in my experience, heavily over-committing CPUs (e.g. a
domain with double or more the vCPU-s that the system has
pCPU-s, or the pCPU-s the domain is allowed to run on) is a
much better test for eventual problems in the spin lock code
paths.

Jan

