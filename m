Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab2JLDh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 23:37:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:28715 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab2JLDhz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 23:37:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,576,1344236400"; 
   d="scan'208";a="233017785"
From: "Ma, Ling" <ling.ma@intel.com>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFC 2/2] [x86] Optimize copy_page by re-arranging
 instruction sequence and saving register
Thread-Topic: [PATCH RFC 2/2] [x86] Optimize copy_page by re-arranging
 instruction sequence and saving register
Thread-Index: AQHNp3KHe7EK2OTz7EWBVGWon0YSZpezpk8AgAFdKsA=
Date: Fri, 12 Oct 2012 03:37:50 +0000
Message-ID: <B2310DA9850C8743AA7AA0055500E90F0FD709F9@SHSMSX102.ccr.corp.intel.com>
References: <1349958548-1868-1-git-send-email-ling.ma@intel.com>
 <20121011143527.GA2408@localhost.localdomain>
In-Reply-To: <20121011143527.GA2408@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Load and write operation occupy about 35% and 10% respectively for
> > most industry benchmarks. Fetched 16-aligned bytes code include about
> > 4 instructions, implying 1.34(0.35 * 4) load, 0.4 write.
> > Modern CPU support 2 load and 1 write per cycle, so throughput from
> > write is bottleneck for memcpy or copy_page, and some slight CPU only
> > support one mem operation per cycle. So it is enough to issue one
> read
> > and write instruction per cycle, and we can save registers.
> 
> So is that also true for AMD CPUs?
Although Bulldozer put 32byte instruction into decoupled 16byte entry buffers,
it still decode 4 instructions per cycle, so 4 instructions will be fed into execution unit and
2 loads ,1 write will be issued per cycle.

Thanks
Ling
