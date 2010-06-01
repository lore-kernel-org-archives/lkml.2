Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab0FAQYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 12:24:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab0FAQYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 12:24:48 -0400
Date: Tue, 1 Jun 2010 19:24:14 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com,
       hpa@zytor.com, mingo@elte.hu, npiggin@suse.de, tglx@linutronix.de,
       mtosatti@redhat.com
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
Message-ID: <20100601162414.GA6191@redhat.com>
References: <20100601093515.GH24302@redhat.com>
 <87sk56ycka.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sk56ycka.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 05:53:09PM +0200, Andi Kleen wrote:
> Gleb Natapov <gleb@redhat.com> writes:
> >
> > The patch below allows to patch ticket spinlock code to behave similar to
> > old unfair spinlock when hypervisor is detected. After patching unlocked
> 
> The question is what happens when you have a system with unfair
> memory and you run the hypervisor on that. There it could be much worse.
> 
How much worse performance hit could be?

> Your new code would starve again, right?
> 
Yes, of course it may starve with unfair spinlock. Since vcpus are not
always running there is much smaller chance then vcpu on remote memory
node will starve forever. Old kernels with unfair spinlocks are running
fine in VMs on NUMA machines with various loads.

> There's a reason the ticket spinlocks were added in the first place.
> 
I understand that reason and do not propose to get back to old spinlock
on physical HW! But with virtualization performance hit is unbearable.

--
			Gleb.
