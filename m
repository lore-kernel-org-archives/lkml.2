Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab2AISAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 13:00:51 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:49690 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795Ab2AISAu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 13:00:50 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Don Zickus <dzickus@redhat.com>, "Luck, Tony" <tony.luck@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        "'ying.huang@intel.com'" <'ying.huang@intel.com'>,
        "'ak@linux.intel.com'" <'ak@linux.intel.com'>,
        "'hughd@chromium.org'" <'hughd@chromium.org'>,
        "'mingo@elte.hu'" <'mingo@elte.hu'>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Mon, 9 Jan 2012 12:59:51 -0500
Subject: RE: [RFC][PATCH v4 -next 1/4] Move kmsg_dump(KMSG_DUMP_PANIC) below
 smp_send_stop()
Thread-Topic: [RFC][PATCH v4 -next 1/4] Move kmsg_dump(KMSG_DUMP_PANIC)
 below smp_send_stop()
Thread-Index: AczL7TiFW1QjzB7DT26CmHrlIGrPywDCmPBw
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C5827BBD8@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C5827AF7F@USINDEVS01.corp.hds.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C5827AF81@USINDEVS01.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28FBB21@ORSMSX104.amr.corp.intel.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C5827B01D@USINDEVS01.corp.hds.com>
 <20120105210123.GI5650@redhat.com>
In-Reply-To: <20120105210123.GI5650@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1201090158
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>I don't know how to prove something is hardened other than not seeing any
>hangs or false reboots on in that piece of code.
>

I don't know how we can prove reliability of smp_send_stop() of all archs as well.

Another possible solution is replacing smp_send_stop() with 
machine_crash_shutdown().
This is a function call stopping other cpus reliably in panic situation
so that kdump can work .
But, I don't know whether it works in all archs.
We need further discussion with Eric for checking this idea is feasible...


I would like to go forward step by step rather than doing tough work at once.
I think just moving kmsg_dump() below smp_send_stop() is a good start for improving pstore.

Seiji
