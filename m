Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab0C2OVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 10:21:01 -0400
Received: from smtp-out.google.com ([216.239.44.51]:58031 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab0C2OU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 10:20:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=QJxWCWDuLzB/EtCnyIp2PficV3s08LAB2TIeYdoo/Q+abrZOawIG0d9VAwa7u+fua
	9pWlvmrIKsND1A4uNuvGA==
MIME-Version: 1.0
In-Reply-To: <1269872024.12097.337.camel@laptop>
References: <20100329122021.765109681@chello.nl>
	 <20100329122138.848413757@chello.nl>
	 <bd4cb8901003290547u1baa58fer762da04790a195ab@mail.gmail.com>
	 <1269872024.12097.337.camel@laptop>
Date: Mon, 29 Mar 2010 15:20:57 +0100
Message-ID: <bd4cb8901003290720j3ab10830vf449e59c40c1e5c0@mail.gmail.com>
Subject: Re: [RFC,PATCH 2/2] perf, x86: Utilize the LBRs for machine/oops 
	debugging
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, Linus Torvalds <torvalds@osdl.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 3:13 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-03-29 at 13:47 +0100, Stephane Eranian wrote:
>> On Mon, Mar 29, 2010 at 1:20 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> > The LBRs are relatively cheap to keep enabled and provide some history
>> > to OOPSen, also some CPUs are reported to keep them over soft-reset,
>> > which allows us to use them to debug things like tripple faults.
>> >
>> > Therefore introduce a boot option: lbr_debug=on, which always enable
>> > the LBRs and will print the LBRs on CPU init and die().
>> >
>>
>> When this is enabled, it will prevent changing the LBR configuration to
>> record only selected branches. Unless you are willing to accept filtered
>> content in the kernel dump.
>
> Sure, but since we don't support that silly config reg anyway that's
> pretty much not an issue ;-)
>
I will provide a patch to make it available. This is needed for certain
measurements.
