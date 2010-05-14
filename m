Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760120Ab0ENXq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 19:46:58 -0400
Received: from p01c11o148.mxlogic.net ([208.65.144.71]:58801 "EHLO
	p01c11o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab0ENXq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 19:46:57 -0400
X-MXL-Hash: 4bede0f155e802e2-1c84de8766d3fb1741c6ca266023376817fcfe54
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 14 May 2010 18:46:48 -0500
Subject: Question about futex_atomic_cmpxchg_inatomic
Thread-Topic: Question about futex_atomic_cmpxchg_inatomic
Thread-Index: Acrzv7f+saos2cXAR3m2pkp4VGNVBQ==
Message-ID: <0D753D10438DA54287A00B0270842697636F05337A@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010050402)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [(unknown)]
X-AnalysisOut: [v=1.0 c=1 a=7t7oAvubNXAA:10 a=ood2b7iyd8MA:10 a=VphdPIyG4k]
X-AnalysisOut: [EA:10 a=IkcTkHD0fZMA:10 a=qS3xps/WtSuafY8lc/WARg==:17 a=rp]
X-AnalysisOut: [bdAngXKw9vgnD23gkA:9 a=hovcRb5Yo14tfKiIFOLtfqcOdBEA:4 a=QE]
X-AnalysisOut: [XdDO2ut3YA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o4ENl4aS030810

Hello all,

futex_atomic_cmpxchg_inatomic is currently defined in all arch's as
something along the line of (this one is from arch/arm):

static inline int
futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
{
	...
}

The only user of this function is in kernel/futex.c and all of the calls
pass u32 type parameters and expect an u32 type return.

Should the all arch implementations be changed to use the u32 type, i.e?

static inline u32
futex_atomic_cmpxchg_inatomic(u32 __user *uaddr, u32 oldval, u32 newval)
{
	...
}

Regards,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
