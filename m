Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab2KSFWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:22:39 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34812 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750808Ab2KSFWh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:22:37 -0500
From: Dan Williams <djbw@fb.com>
To: NeilBrown <neilb@suse.de>
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] raid5: panic() on dma_wait_for_async_tx() error
Thread-Topic: [PATCH] raid5: panic() on dma_wait_for_async_tx() error
Thread-Index: AQHNvZjcZvdj89zKhkaeKpWCze4X2JfgT58AgAABiICAEJ39AP//sJeA
Date: Mon, 19 Nov 2012 05:22:25 +0000
Message-ID: <84A937D219C2B44EB8EA44831ACA1E49166C741F@SC-MBX02-3.TheFacebook.com>
In-Reply-To: <20121119120632.1c97e306@notabene.brown>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.18.254]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1E3BA5E6BE7269468734F0EB6B583FCE@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Reason: safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8185,1.0.431,0.0.0000
 definitions=2012-11-19_02:2012-11-15,2012-11-19,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/18/12 5:06 PM, "NeilBrown" <neilb@suse.de> wrote:

>
>Hi Dan,
> could you comment on this please?  Would it make sense to arrange for
>errors
> to propagate up?  Or should we arrange to do a software-fallback in the
>dma
> engine is a problem?  What sort of things can cause error here anyway?

Propagating up is missing reliable "dma abort" operation.

In these cases the engine failed to complete due to hardware hang / driver
bug, or has hit a memory error (uncorrectable even with software
fallback).  This originally should have been using async_tx_quiesce()
which also does the panic.

The engines that I have worked with have either lacked support for
aborting, or were otherwise unable to recover from a hardware hang.
However, for engines that do support error recovery they should be able to
hide the failure from the upper layers.

--
Dan

