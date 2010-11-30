Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab0K3Kgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 05:36:54 -0500
Received: from mga03.intel.com ([143.182.124.21]:24986 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249Ab0K3Kgw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 05:36:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,279,1288594800"; 
   d="scan'208";a="354895092"
From: "Gao, Yunpeng" <yunpeng.gao@intel.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 30 Nov 2010 18:36:50 +0800
Subject: RE: [PATCH v1 3/3]mmc: changes to enable runtime PM of mmc core
 layer
Thread-Topic: [PATCH v1 3/3]mmc: changes to enable runtime PM of mmc core
 layer
Thread-Index: AcuQbJ5cuERcQn5FQSuC6T5P0SvC9QADTctA
Message-ID: <CE761E84DADF2947A4AF22FB8D97A4733073B826@shsmsx501.ccr.corp.intel.com>
References: <20101128055315.GD3318@intel.com>
 <AANLkTiknO0BEBetKmFT5W0qwW+q1pS59qcwiqSMUHa_u@mail.gmail.com>
In-Reply-To: <AANLkTiknO0BEBetKmFT5W0qwW+q1pS59qcwiqSMUHa_u@mail.gmail.com>
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

>You shouldn't do this here.
>
>You didn't comment about or mentioned this change, but I guess you did
>it because you (quite reasonably) didn't want the card to be powered
>off as soon as mmc_blk_issue_rq() completes, and instead, you
>preferred to wait until some period of inactivity time passes.
>
>But that's not true for all mmc buses: e.g., when an SDIO function
>driver decides it's time to power off the card (e.g. user disables the
>wlan interface), there is no reason to have this delay.
>
>In addition, putting an inherent delay here will completely prevent
>anyone from achieving a synchronous idle notification on an mmc card
>(so even pm_runtime_put_sync() will now set a timer to submit a
>suspend request instead of carrying out a synchronous suspend).
>
>It looks like you can drop this change, and instead just use the
>autosuspend API from the mmc block driver (mainly use
>pm_runtime_put_autosuspend() instead of pm_runtime_put()).
>
>Another nice benefit of autosuspend is that now user space will be
>able to tweak the amount of delay by using
>/sys/devices/.../power/autosuspend_delay_ms attribute.

Thanks a lot for the nice review and comments. They're very valuable to me. I'll read it carefully and resubmit these patches later.
Thank you again :-)

