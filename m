Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab2IEBxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 21:53:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:23407 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502Ab2IEBxs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 21:53:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,371,1344236400"; 
   d="scan'208";a="141558603"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
CC: "airlied@redhat.com" <airlied@redhat.com>,
        "alexander.deucher@amd.com" <alexander.deucher@amd.com>,
        "Shi, Yang A" <yang.a.shi@intel.com>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: [Patch 0/1]drm_irq: Introducing the irq_thread support
Thread-Topic: [Patch 0/1]drm_irq: Introducing the irq_thread support
Thread-Index: Ac2LCUW31F8w5RR8Th6qv7Us2nL6nQ==
Date: Wed, 5 Sep 2012 01:53:44 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A177306@SHSMSX101.ccr.corp.intel.com>
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

This patch is for introducing the irq thread support in drm_irq.

Why we need irq thread in drm_irq code?
In our GPU system, the gpu interrupt handler need some time even > 1ms to finish,
in that case, the whole system will stay in irq disable status. One case is:
when audio is playing, it sometimes effects the audio quality.

So we have to introduce the irq thread in drm_irq, it can help us move some heavy work into irq thread
and other irq interrupts can be handled in time. Also the IRQF_ONESHOT is helpful for irq thread.

Include one patch:
[PATCH 01/1] drm_irq-Introducing-the-irq_thread-support
