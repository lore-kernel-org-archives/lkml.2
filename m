Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab0IQPK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:10:28 -0400
Received: from usindmx04.hds.com ([207.126.252.15]:42524 "EHLO
	usindmx04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab0IQPKH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:10:07 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "simon.kagstrom@netinsight.net" <simon.kagstrom@netinsight.net>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>
Date: Fri, 17 Sep 2010 11:08:48 -0400
Subject: RE: [PATCH] Fix kexec abort due to IPI from panic().
Thread-Topic: [PATCH] Fix kexec abort due to IPI from panic().
Thread-Index: ActV9NeRGIQilg9bRH6SmEJa3/stIgAhGvTA
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C09821A9E@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C0979C90E@USINDEVS01.corp.hds.com>
 <m1wrql2sf1.fsf@fess.ebiederm.org>
In-Reply-To: <m1wrql2sf1.fsf@fess.ebiederm.org>
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

Hi Eric,

Thank you for your quick response!

>Disabling interrupts is fine,

Thanks!

>However that call to kmsg_dump(KMSG_DUMP_KEXEC) is a bug as it introduces locks 
>into a path that should not be taking locks.

I'd like to find a way that kexec coexists with kmsg_dump(KMSG_DUMP_KEXEC) because 
kmsg_dump is a useful troubleshooting feature as well.

So, I will improve kmsg_dump(KMSG_DUMP_KEXEC) if there are some bugs.
Could you please let me know your concern?
It is helpful for me if you have an example scenario kexec fails.

>Nothing in the crash_kexec path should even have the option of blocking.

Do you mean I need to change kmsg_dump(KMSG_DUMP_KEXEC) to lockless?

Seiji
