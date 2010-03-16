Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab0CPWan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 18:30:43 -0400
Received: from 8bytes.org ([88.198.83.132]:40202 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab0CPWam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 18:30:42 -0400
Date: Tue, 16 Mar 2010 23:30:40 +0100
From: oerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
	host side
Message-ID: <20100316223040.GH13108@8bytes.org>
References: <4B9F19F7.6000309@redhat.com> <20100316072449.GB11881@elte.hu> <4B9F4D74.4090403@redhat.com> <20100316095336.GI7961@elte.hu> <4B9F59DE.1060008@redhat.com> <20100316102052.GC10069@elte.hu> <4B9F603B.4080004@redhat.com> <20100316105021.GA14344@elte.hu> <4B9F671D.5060001@redhat.com> <20100316112500.GA5337@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316112500.GA5337@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 12:25:00PM +0100, Ingo Molnar wrote:
> Hm, that sounds rather messy if we want to use it to basically expose kernel 
> functionality in a guest/host unified way. Is the qemu process discoverable in 
> some secure way? Can we trust it? Is there some proper tooling available to do 
> it, or do we have to push it through 2-3 packages to get such a useful feature 
> done?

Since we want to implement a pmu usable for the guest anyway why we
don't just use a guests perf to get all information we want? If we get a
pmu-nmi from the guest we just re-inject it to the guest and perf in the
guest gives us all information we wand including kernel and userspace
symbols, stack traces, and so on.

In the previous thread we discussed about a direct trace channel between
guest and host kernel (which can be used for ftrace events for example).
This channel could be used to transport this information to the host
kernel.

The only additional feature needed is a way for the host to start a perf
instance in the guest.

Opinions?


	Joerg

