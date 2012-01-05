Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309Ab2AEULS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 15:11:18 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:56748 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab2AEULR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 15:11:17 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Luck, Tony" <tony.luck@intel.com>, Don Zickus <dzickus@redhat.com>
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
Date: Thu, 5 Jan 2012 15:10:25 -0500
Subject: RE: [RFC][PATCH v4 -next 1/4] Move kmsg_dump(KMSG_DUMP_PANIC) below
 smp_send_stop()
Thread-Topic: [RFC][PATCH v4 -next 1/4] Move kmsg_dump(KMSG_DUMP_PANIC)
 below smp_send_stop()
Thread-Index: AQHMy9CqWb3Eal+luUidUg+JrwynPJX+IWHAgAAOOEA=
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C5827B01D@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C5827AF7F@USINDEVS01.corp.hds.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C5827AF81@USINDEVS01.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28FBB21@ORSMSX104.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28FBB21@ORSMSX104.amr.corp.intel.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=2 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1201050226
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>Aren't you worried about the comment about smp_send_stop() not
>being hardened to work in a panic situation?
> 	/*
> 	 * Note smp_send_stop is the usual smp shutdown function, which
> 	 * unfortunately means it may not be hardened to work in a panic

This comment is wrong because Don improved smp_send_stop() by switching REBOOT_VECTOR to NMI.
And his patch has already merged to linux-next tree.

http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=3603a2512f9e69dc87914ba922eb4a0812b21cd6

So, current smp_send_stop() is hardened to work in a panic situation.

I will remove this wrong comment.

Seiji

>-----Original Message-----
>From: Luck, Tony [mailto:tony.luck@intel.com]
>Sent: Thursday, January 05, 2012 2:07 PM
>To: Seiji Aguchi; Don Zickus
>Cc: linux-kernel@vger.kernel.org; Matthew Garrett; Vivek Goyal; Chen, Gong; akpm@linux-foundation.org; Brown, Len;
>'ying.huang@intel.com'; 'ak@linux.intel.com'; 'hughd@chromium.org'; 'mingo@elte.hu'; jmorris@namei.org;
>a.p.zijlstra@chello.nl; namhyung@gmail.com; dle-develop@lists.sourceforge.net; Satoru Moriya
>Subject: RE: [RFC][PATCH v4 -next 1/4] Move kmsg_dump(KMSG_DUMP_PANIC) below smp_send_stop()
>
>-	kmsg_dump(KMSG_DUMP_PANIC);
>-
> 	/*
> 	 * Note smp_send_stop is the usual smp shutdown function, which
> 	 * unfortunately means it may not be hardened to work in a panic
>@@ -117,6 +115,8 @@ void panic(const char *fmt, ...)
> 	 */
> 	smp_send_stop();
>
>+	kmsg_dump(KMSG_DUMP_PANIC);
>+
>
>Aren't you worried about the comment about smp_send_stop() not
>being hardened to work in a panic situation?
>
>If it does work - we are clearly much better off moving the
>kmsg_dump() call down like this. It makes life much simpler
>and cleaner to work with just one running cpu.
>
>But if something goes wrong - we might not see the dump at all!
>
>How do we compare these cases and decide that it is better to
>trust that smp_send_stop() will return?
>
>-Tony
