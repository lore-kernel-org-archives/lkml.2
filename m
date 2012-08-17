Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab2HQVmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 17:42:21 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:47056 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab2HQVmN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 17:42:13 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Mike Waychison <mikew@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][PATCH 2/2] efi_pstore: Introducing workqueue updating
 sysfs entries
Thread-Topic: [RFC][PATCH 2/2] efi_pstore: Introducing workqueue updating
 sysfs entries
Thread-Index: Ac18sHkwmdnRbMTcT9KbT5zgh21KoAAKK1YAAAgJvvD//861AIAAQMkA
Date: Fri, 17 Aug 2012 21:41:58 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D413800199@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D413800090@USINDEM103.corp.hds.com>
 <CAGTjWtA-zE-UCsqC5H4VvLfz94J_5bjYzMwF5RaHLdr9O_MoRA@mail.gmail.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D413800155@USINDEM103.corp.hds.com>
 <CAGTjWtAiW1=BVTj0HdkVRbq5DVJjFs7jjNLp6bSVXmGq6rcvkA@mail.gmail.com>
In-Reply-To: <CAGTjWtAiW1=BVTj0HdkVRbq5DVJjFs7jjNLp6bSVXmGq6rcvkA@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-08-17_05:2012-08-17,2012-08-17,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1208170243
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You could, but why not always just schedule_work()?  If we are hosed by broken workqueue/scheduler locking, the user isn't going to
> see those files in sysfs either way :) 

I'm not concern about failure of sysfs operations.
In panic function call, panic_notifier_chain is kicked. Also users may expect the system reboots in panic case 
by specifying /proc/sys/kernel/panic.

I just would like to avoid failures of those operations without adding unnecessary calls in the write callback.

> If you are going to insist that we shouldn't schedule_work() in the other cases, I'd prefer:
> 
> /* The user may want to see an entry for this write in sysfs. */ if (reason == KMSG_DUMP_OOPS)
>         schedule_work(...);
>

Thank you for your suggestion. I will update my patch by adding this logic above.
