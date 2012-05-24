Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964930Ab2EXRSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 13:18:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:45337 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966Ab2EXRSl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 13:18:41 -0400
Message-ID: <1337879916.9698.69.camel@twins>
Subject: Re: perf, x86: only do lbr init if bts is available
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Date: Thu, 24 May 2012 19:18:36 +0200
In-Reply-To: <4FBE5FA6.5050802@gmail.com>
References: <4FBE5FA6.5050802@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 10:19 -0600, David Ahern wrote:
> KVM recently added support for a version 2 PMU. When passing -cpu host 
> as the CPU model for the guest we get an abnormal configuration from 
> perf's perspective in that the guest identifies the processor as a 
> Westmere or Nehalem (etc):
> 
> [    0.013998] Performance Events: Westmere events, Intel PMU driver.
> 
> 
> but yet the processor does not have the debug store mechanisms 
> (X86_FEATURE_DTES64 is not set) meaning there is no PEBS or BTS.
> 
> Right now the LBR init functions are run based on processor model which 
> leads to attempts to write to LBR MSRs generating messages like:

Right, as Stephane already noted, LBR is not an CPUID enumerated
feature, hence the only thing you can do is go by model. So if you set
qemu -cpu host but fail to implement all the architectural MSRs that go
with that model you get to keep the pieces.

Not really our problem.
