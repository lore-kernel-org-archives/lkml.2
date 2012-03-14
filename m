Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761154Ab2CNRwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 13:52:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:36407 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756688Ab2CNRws convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 13:52:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="121010904"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: Adalbert Dawid <dawid@rinux.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "x86@kernel.org" <x86@kernel.org>
Subject: RE: Kernel Panic with Rawtherapee (mce related)
Thread-Topic: Kernel Panic with Rawtherapee (mce related)
Thread-Index: AQHNAfJ8aeq5R/7dC0Geu08XqQtP/ZZqaDgA//+nNZA=
Date: Wed, 14 Mar 2012 17:51:45 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F15B64BF0@ORSMSX103.amr.corp.intel.com>
References: <1331678930.11814.16.camel@erde.fritz.box>
 <4F60B0E3.6020503@linux.vnet.ibm.com> <20120314155906.GA25286@aftab>
In-Reply-To: <20120314155906.GA25286@aftab>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You're getting a bunch of machine checks, the last one of them being
> fatal (Process Context Corrupt bit is set) causing the machine to panic.

PCC is set in all of them

> Tony will probably be able to help you further in decoding what exactly
> those MC0_STATUS and MC5_STATUS values mean

Bank 5 ends in 0400 - which means "Internal timer error". Bank 0 has 0800
which is a bus/interconnect error where this processor was the source of
a memory transaction.

That's where the facts end - speculation begins here ...

Since this is repeatable under load - it's possible that a page table got
corrupted and you are trying to access some non-existent memory location?
Do all traces for this panic involve *_tlb_* functions?

Or perhaps you have a cooling problem - and when stressed your cpu or
memory is getting too hot?

-Tony

