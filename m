Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab0JYLvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 07:51:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244Ab0JYLu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 07:50:59 -0400
Message-ID: <4CC56F10.8040803@redhat.com>
Date: Mon, 25 Oct 2010 13:50:40 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] kvm: write protect memory after slot swap
References: <20101025012124.GA31262@redhat.com> <4CC54EB8.9020604@redhat.com> <4CC56CC6.4020703@siemens.com>
In-Reply-To: <4CC56CC6.4020703@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/25/2010 01:40 PM, Jan Kiszka wrote:
> >
> >  Excellent catch, I stared at this code for a while and didn't see the
> >  bug.  Patch applied.
> >
>
> BTW, while this was an annoying one for graphic emulation, wasn't it
> potentially lethal for live migration?

Deadly.  Yes autofs passed it happily.

We need a unit test that bangs on pages and the bitmap with tighter timing.

> The issue looks like is was introduced with the switch to SRCU, so every
> kernel since 2.6.34 should be affected, correct?

Yes.

-- 
error compiling committee.c: too many arguments to function

