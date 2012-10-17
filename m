Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab2JQDgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 23:36:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:3600 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690Ab2JQDgP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 23:36:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,597,1344236400"; 
   d="scan'208";a="228514178"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] x86/ioapic: fix the irq_2_pin mem leak when destroy_irq
Thread-Topic: [PATCH] x86/ioapic: fix the irq_2_pin mem leak when destroy_irq
Thread-Index: AQHNrAuC4qnOuCFjlUW0E781HzncsZe8164A
Date: Wed, 17 Oct 2012 03:36:12 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A1A18B9@SHSMSX101.ccr.corp.intel.com>
References: <1350468706.15558.26.camel@cliu38-desktop-build>
 <CAE9FiQXFvuWS3HPBefUDS+a8VT_2=xtbjFowoPqZcwJSoKt_Hg@mail.gmail.com>
In-Reply-To: <CAE9FiQXFvuWS3HPBefUDS+a8VT_2=xtbjFowoPqZcwJSoKt_Hg@mail.gmail.com>
Accept-Language: zh-CN, en-US
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

> -----Original Message-----
> From: yhlu.kernel@gmail.com [mailto:yhlu.kernel@gmail.com] On Behalf Of
> Yinghai Lu
> Sent: Wednesday, October 17, 2012 10:03 AM
> To: Liu, Chuansheng
> Cc: tglx@linutronix.de; mingo@redhat.com; Siddha, Suresh B;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] x86/ioapic: fix the irq_2_pin mem leak when destroy_irq
> 
> On Wed, Oct 17, 2012 at 3:11 AM, Chuansheng Liu
> <chuansheng.liu@intel.com> wrote:
> >
> > When destroying the irq, before free cfg, need to check
> > cfg->irq_2_pin and free it when it is not NULL.
> >
> > Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> > ---
> 
> i had that in another patch...
> 
> https://lkml.org/lkml/2012/2/23/574
Sorry to not know that.
> 
> ----
> Subject	[PATCH 01/13] x86, irq: Convert irq_2_pin list to generic list
> Date	Thu, 23 Feb 2012 19:48:47 -0800
> 
> So we can use generic list helper function.
Does it really need the generic list with both prev and next pointers?
For irq_2_pin list, the next pointer seems be enough.

> 
> Also make free_irq_cfg() free irq_2_pin list.
> ----
> 
> http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commitdiff;
> h=4010f4dbd1b172e3080d3e6c459a58c4b575f081
> 
> Yinghai
