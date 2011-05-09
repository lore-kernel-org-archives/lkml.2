Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455Ab1EIApF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 20:45:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:59654 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173Ab1EIApE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 20:45:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,337,1301900400"; 
   d="scan'208";a="744201374"
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Date: Mon, 9 May 2011 08:44:30 +0800
Subject: RE: [PATCH v2 2/2] x86: don't unmask disabled irqs when migrating
 them
Thread-Topic: [PATCH v2 2/2] x86: don't unmask disabled irqs when migrating
 them
Thread-Index: AcwNIYwayE5RhRYQQIuk4+pP5iqa1gAwEQiQ
Message-ID: <625BA99ED14B2D499DC4E29D8138F1505C8ED7FAA0@shsmsx502.ccr.corp.intel.com>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com>
	 <alpine.LFD.2.02.1105061149330.3005@ionos>
	 <625BA99ED14B2D499DC4E29D8138F1505C8ED7F962@shsmsx502.ccr.corp.intel.com>
	 <alpine.LFD.2.02.1105061505010.3005@ionos>
 <1304690697.26692.176.camel@zakaz.uk.xensource.com>
 <4DC5F596.4090303@goop.org>
In-Reply-To: <4DC5F596.4090303@goop.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p490jP64022349

> From: Jeremy Fitzhardinge [mailto:jeremy@goop.org]
> Sent: Sunday, May 08, 2011 9:45 AM
> 
> On 05/07/2011 12:04 AM, Ian Campbell wrote:
> > I'm not really sure why these can't just be an evtchn without an
> > associated IRQ since it doesn't really have any interrupt-like
> > semantics. Perhaps just a general desire to keep event channels
> > abstracted into the core Xen event subsystem with IRQs as the public
> > facing API? Jeremy?
> 
> It doesn't really need to be an irq.  The main reason was so that it would
> appear in /proc/interrupts so I could use the counter as a "number of times a
> spinlock was kicked" counter.  That could be exposed in some other way if
> being part of the interrupt infrastructure brings too much baggage with it.
> 

Perhaps we don't need an irq binding here. Just like a local APIC interrupt
source which only needs vector. Somehow the virq or vipi concept in Xen
context is similar.

Thanks
Kevin
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
