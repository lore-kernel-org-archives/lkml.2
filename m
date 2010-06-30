Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab0F3LVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 07:21:52 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:38744 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab0F3LVv convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Wed, 30 Jun 2010 07:21:51 -0400
Message-Id: <4C2B45080200007800008C97@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 30 Jun 2010 12:22:16 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "Ky Srinivasan" <KSrinivasan@novell.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH 4/4, v2] x86: enlightenment for ticket spin locks
	 -	 improve yield behavior on Xen
References: <4C2A20E30200007800008A17@vpn.id2.novell.com>
 <4C2B17AE.8000002@goop.org>
In-Reply-To: <4C2B17AE.8000002@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.06.10 at 12:08, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> On 06/29/2010 04:35 PM, Jan Beulich wrote:
>> --- 2.6.35-rc3-virt-spinlocks.orig/arch/x86/include/asm/spinlock.h
>> +++ 2.6.35-rc3-virt-spinlocks/arch/x86/include/asm/spinlock.h
>> @@ -85,6 +85,15 @@ extern void virt_spin_unlock_stub(void);
>>  # define UNLOCK_LOCK_PREFIX
>>  #endif
>>  
>> +static __always_inline void __ticket_spin_set_owner(arch_spinlock_t *lock,
>> +                                                    int owned)
>> +{
>> +#ifdef CONFIG_ENLIGHTEN_SPINLOCKS
>> +	if (owned)
>> +		lock->owner = percpu_read(cpu_number);
>>   
> 
> Why not smp_processor_id()?  Is this different in some way?

Including the respective header here just doesn't work due to
resulting cyclic dependencies.

Jan

