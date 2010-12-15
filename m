Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab0LOQkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:40:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:36915 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab0LOQkL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:40:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,349,1288594800"; 
   d="scan'208";a="868565146"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Huang, Ying" <ying.huang@intel.com>, Len Brown <lenb@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Date: Wed, 15 Dec 2010 08:40:09 -0800
Subject: RE: [RFC] ACPI, APEI, Generic Hardware Error Source POLL/IRQ/NMI
 notification type support
Thread-Topic: [RFC] ACPI, APEI, Generic Hardware Error Source POLL/IRQ/NMI
 notification type support
Thread-Index: AcucGa/zcDU6xkcbTlmIxJxsu+huFgAXKT5Q
Message-ID: <987664A83D2D224EAE907B061CE93D530193C9D504@orsmsx505.amr.corp.intel.com>
References: <1292391242.12648.1202.camel@yhuang-dev>
In-Reply-To: <1292391242.12648.1202.camel@yhuang-dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Because the memory area used to transfer hardware error information
>from BIOS to Linux can be determined only in NMI, IRQ or timer
>handler, but general ioremap can not be used in atomic context, so a
>special version of atomic ioremap is implemented for that.
>
>Known issue:
>
>- Error information can not be printed for recoverable errors notified
>  via NMI, because printk is not NMI-safe. Will fix this via delay
>  printing to IRQ context via irq_work or make printk NMI-safe.

Would it be possible to defer the "ioremap" to a work queue too? Then
we wouldn't need the special versions of ioremap.

-Tony
