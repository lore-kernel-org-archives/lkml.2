Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009Ab2JKQrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 12:47:04 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:16501 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab2JKQq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 12:46:59 -0400
From: "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Croxon, Nigel" <nigel.croxon@hp.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "agordeev@redhat.com" <agordeev@redhat.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>
Subject: RE: [PATCH] fix x2apic defect that Linux kernel doesn't mask 8259A
 interrupt during the time window between changing VT-d table base address
 and initializing these VT-d entries(smpboot.c and apic.c )
Thread-Topic: [PATCH] fix x2apic defect that Linux kernel doesn't mask 8259A
 interrupt during the time window between changing VT-d table base address
 and initializing these VT-d entries(smpboot.c and apic.c )
Thread-Index: AQHNpbB+Rz0tU9hpbEaEjcKbxJEEKZexnhfwgAF40ICAACTkgIABFSNA
Date: Thu, 11 Oct 2012 16:46:29 +0000
Message-ID: <92645B27BF79D04FBD2B0F8494FFD0F9102B85@G2W2429.americas.hpqcorp.net>
References: <92645B27BF79D04FBD2B0F8494FFD0F90FC806@G2W2429.americas.hpqcorp.net>
	 <1349740633.11093.43.camel@sbsiddha-desk.sc.intel.com>
	  <92645B27BF79D04FBD2B0F8494FFD0F9102841@G2W2429.americas.hpqcorp.net>
 <1349913700.3042.7.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1349913700.3042.7.camel@sbsiddha-desk.sc.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.193.232.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9BGl7cO012042


> -----Original Message-----
> From: Suresh Siddha [mailto:suresh.b.siddha@intel.com]
> Sent: 2012å¹´10æœˆ10æ—¥ 18:02
> > > So I looked at why you are seeing the problem with v2.6.32 but not
> > > with the recent kernels. And I think I found out the reason.
> >
> > I want to know what masking IO-APIC means?
> 
> As the platform is configured to use virtual-wire B and the corresponding
> IO-APIC RTE is masked, that interrupt will be dropped.
> 
thanks for your explanation and confirm, I also consulted BIOS guys , 
yes, interrupt will be dropped , software didn't see them,and don't go to handle them. 
So we OS don't need to disable 8259A interrupt during the window 
, only if 2.6.32 has applied your patch(triggered some actions to mask IO-apic)
That's good. Perfect design . thanks.

Here we go!
  
---------------
-- Bob(LinBao Zhang)
HP linux kernel enginner


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
