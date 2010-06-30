Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab0F3KK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 06:10:28 -0400
Received: from claw.goop.org ([74.207.240.146]:57762 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381Ab0F3KKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 06:10:25 -0400
Message-ID: <4C2B180E.9060104@goop.org>
Date: Wed, 30 Jun 2010 12:10:22 +0200
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       ksrinivasan <ksrinivasan@novell.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH 4/4, v2] x86: enlightenment for ticket spin locks -	 improve
 yield behavior on Xen
References: <4C2A20E30200007800008A17@vpn.id2.novell.com> <1277885485.1868.74.camel@laptop> <4C2B21300200007800008BDC@vpn.id2.novell.com>
In-Reply-To: <4C2B21300200007800008BDC@vpn.id2.novell.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2010 10:49 AM, Jan Beulich wrote:
>>>> On 30.06.10 at 10:11, Peter Zijlstra <peterz@infradead.org> wrote:
>>>>         
>> On Tue, 2010-06-29 at 15:35 +0100, Jan Beulich wrote:
>>     
>>> The (only) additional overhead this introduces for native execution is
>>> the writing of the owning CPU in the lock acquire paths. 
>>>       
>> Uhm, and growing the size of spinlock_t to 6 (or 8 bytes when aligned)
>> bytes when NR_CPUS>256.
>>     
> Indeed, I should have mentioned that. Will do so in an eventual
> next version.
>   

Rather than increasing the lock size, why not just disable the
enlightenment if the number of (possible) cpus is > 256?  I don't think
a VM will ever have that many cpus, so it will only apply in the case of
booting the kernel on large physical machine.

    J
