Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab1EIBpf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 21:45:35 -0400
Received: from claw.goop.org ([74.207.240.146]:48905 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756617Ab1EIBpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 21:45:19 -0400
Message-ID: <4DC74729.9090508@goop.org>
Date: Mon, 09 May 2011 11:45:13 +1000
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: "Tian, Kevin" <kevin.tian@intel.com>
CC: Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH v2 2/2] x86: don't unmask disabled irqs when migrating
 them
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com>	 <alpine.LFD.2.02.1105061149330.3005@ionos>	 <625BA99ED14B2D499DC4E29D8138F1505C8ED7F962@shsmsx502.ccr.corp.intel.com>	 <alpine.LFD.2.02.1105061505010.3005@ionos> <1304690697.26692.176.camel@zakaz.uk.xensource.com> <4DC5F596.4090303@goop.org> <625BA99ED14B2D499DC4E29D8138F1505C8ED7FAA0@shsmsx502.ccr.corp.intel.com>
In-Reply-To: <625BA99ED14B2D499DC4E29D8138F1505C8ED7FAA0@shsmsx502.ccr.corp.intel.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2011 10:44 AM, Tian, Kevin wrote:
>> It doesn't really need to be an irq.  The main reason was so that it would
>> appear in /proc/interrupts so I could use the counter as a "number of times a
>> spinlock was kicked" counter.  That could be exposed in some other way if
>> being part of the interrupt infrastructure brings too much baggage with it.
>>
> Perhaps we don't need an irq binding here. Just like a local APIC interrupt
> source which only needs vector. Somehow the virq or vipi concept in Xen
> context is similar.

An event channel is logically equivalent to a vector, so that would make
sense.  We currently allocate irqs for cross-cpu call and reschedule
event channels, whereas native x86 simply uses a naked vector for
those.  But they are real interrupts, so an irq at least makes some
logical sense in those cases.

For spinlocks, the event channel is more like a usermode-level signal
which is always blocked and only ever tested with sigsuspend (or is it
sigpoll?  something like that).

    J
