Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646Ab1LNRbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 12:31:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755129Ab1LNRbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 12:31:19 -0500
Message-ID: <4EE8DD53.5010408@redhat.com>
Date: Wed, 14 Dec 2011 19:30:59 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Eric B Munson <emunson@mgebm.net>
CC: Marcelo Tosatti <mtosatti@redhat.com>, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com,
        jeremy.fitzhardinge@citrix.com, levinsasha928@gmail.com,
        Jan Kiszka <jan.kiszka@siemens.com>, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5 V5] Add functions to check if the host has stopped
 the vm
References: <1323116344-17911-1-git-send-email-emunson@mgebm.net> <1323116344-17911-3-git-send-email-emunson@mgebm.net> <4EDF78C5.8060908@redhat.com> <20111208152310.GB6301@mgebm.net> <20111214121124.GA18317@amt.cnet> <4EE8B4AD.2060101@redhat.com> <20111214171105.GB4075@mgebm.net>
In-Reply-To: <20111214171105.GB4075@mgebm.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 07:11 PM, Eric B Munson wrote:
> > > > 
> > > > If I understand (please correct me if this is wrong) because this is only
> > > > called from the watchdog, which disables preemption, we should be protected
> > > > from something else writing to these flags.
> > >
> > > The host can write, but in that case race is harmless.
> > 
> > Why is it harmless?  You don't know what's in those other flags.
> > 
> > -- 
> > error compiling committee.c: too many arguments to function
> > 
>
> Currently there is only one other flag in this byte (PVCLOCK_TSC_STABLE_BIT)
> and it isset once in kvmclock_init().  It is highly unlikely that the vm will
> be stopped during this init and have the flag clobbered.  After the tsc stable
> bit is written in the init, the field is read only outside of the guest paused
> code.

Let's not lay minefields for us later to step into.  Making this a
cpu-local atomic (irq safe but not smp safe) is simple and easy,
somehting like __this_cpu_and().

-- 
error compiling committee.c: too many arguments to function

