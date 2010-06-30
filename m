Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab0F3OmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 10:42:24 -0400
Received: from claw.goop.org ([74.207.240.146]:59967 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237Ab0F3OmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 10:42:23 -0400
Message-ID: <4C2B57CA.3070807@goop.org>
Date: Wed, 30 Jun 2010 16:42:18 +0200
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: "mingo@elte.hu" <mingo@elte.hu>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       Ky Srinivasan <KSrinivasan@novell.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH 2/4, v2] x86: enlightenment for ticket spin locks -	 Xen
 implementation
References: <4C2A200F02000078000089E4@vpn.id2.novell.com> <4C2B1769.5090107@goop.org> <4C2B47190200007800008CB7@vpn.id2.novell.com> <4C2B4564.7030203@goop.org> <4C2B6AD60200007800008D90@vpn.id2.novell.com> <4C2B53D1.90101@goop.org> <4C2B72950200007800008DBA@vpn.id2.novell.com>
In-Reply-To: <4C2B72950200007800008DBA@vpn.id2.novell.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2010 04:36 PM, Jan Beulich wrote:
> Are we perhaps talking about different things? I'm referring to
>
> static __always_inline void arch_spin_unlock(struct arch_spinlock *lock)
> {
> 	PVOP_VCALL1(pv_lock_ops.spin_unlock, lock);
> }
>
> which is an indirect call which, as I understand it, gets replaced
> with a direct one at runtime. But it remains to be a call (as opposed
> to being a single inc instructions without CONFIG_PARAVIRT_SPINLOCKS).
>   

Sorry, I'm referring to pv ticketlocks, not the current
PARAVIRT_SPINLOCKS code.  I agree the current PARAVIRT_SPINLOCKS
implementation is suboptimal and needs to be replaced with something
that's only called on the slow path.  I just think the existing
paravirt_ops mechanism can be used to implement it rather than adding
something new.

    J
