Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab2A3DSG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 22:18:06 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7336 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab2A3DSE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 22:18:04 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 29 Jan 2012 19:18:03 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 30 Jan 2012 08:47:59 +0530
Subject: RE: [PATCH] rtc: twl: optimize IRQ bit access
Thread-Topic: [PATCH] rtc: twl: optimize IRQ bit access
Thread-Index: AczdVUEUjq5EVV0iSpq0ckqVp8gOPQBqBfow
Message-ID: <D958900912E20642BCBC71664EFECE3E6DD05B2EB0@BGMAIL02.nvidia.com>
References: <1326973942-11576-1-git-send-email-vbyravarasu@nvidia.com>
 <20120127163840.ff030c49.akpm@linux-foundation.org>
In-Reply-To: <20120127163840.ff030c49.akpm@linux-foundation.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Saturday, January 28, 2012 6:09 AM
> To: Venu Byravarasu
> Cc: a.zummo@towertech.it; rtc-linux@googlegroups.com; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] rtc: twl: optimize IRQ bit access
> 
> Are these functions called frequently enough to make this optimisation
> significant?
I did not check how frequent these functions are called.
However, as the values are cached any way, thought of using them before doing hardware access.
> 
> I can see no locking protecting rtc_irq_bits from concurrent updaters.
> Is this code as racy as it appears?
Yes, looks like it is. Will push a separate patch to fix this issue.

