Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab1EHBo7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 21:44:59 -0400
Received: from claw.goop.org ([74.207.240.146]:38432 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095Ab1EHBo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 21:44:58 -0400
Message-ID: <4DC5F596.4090303@goop.org>
Date: Sun, 08 May 2011 11:44:54 +1000
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
CC: Thomas Gleixner <tglx@linutronix.de>, "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH v2 2/2] x86: don't unmask disabled irqs when migrating
 them
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com>	 <alpine.LFD.2.02.1105061149330.3005@ionos>	 <625BA99ED14B2D499DC4E29D8138F1505C8ED7F962@shsmsx502.ccr.corp.intel.com>	 <alpine.LFD.2.02.1105061505010.3005@ionos> <1304690697.26692.176.camel@zakaz.uk.xensource.com>
In-Reply-To: <1304690697.26692.176.camel@zakaz.uk.xensource.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2011 12:04 AM, Ian Campbell wrote:
> I'm not really sure why these can't just be an evtchn without an
> associated IRQ since it doesn't really have any interrupt-like
> semantics. Perhaps just a general desire to keep event channels
> abstracted into the core Xen event subsystem with IRQs as the public
> facing API? Jeremy?

It doesn't really need to be an irq.  The main reason was so that it
would appear in /proc/interrupts so I could use the counter as a "number
of times a spinlock was kicked" counter.  That could be exposed in some
other way if being part of the interrupt infrastructure brings too much
baggage with it.

    J
