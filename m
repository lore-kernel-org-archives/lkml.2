Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab2GYX2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 19:28:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:9540 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab2GYX2l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 19:28:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="173231625"
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@kernel.org" <mingo@kernel.org>
CC: "hpa@zytor.com" <hpa@zytor.com>, "yinghai@kernel.org" <yinghai@kernel.org>,
        "agordeev@redhat.com" <agordeev@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: RE: [PATCH] x86/ioapic: Fix NULL pointer dereference on CPU hotplug
 after disabling irqs
Thread-Topic: [PATCH] x86/ioapic: Fix NULL pointer dereference on CPU
 hotplug after disabling irqs
Thread-Index: AQHNakZbmR/J+8FGp0y9EYVC+FOQdJc6pJ1w
Date: Wed, 25 Jul 2012 23:28:38 +0000
Message-ID: <BC5CD145C5D9E74D86490E60F52766FF1EBCFCDD@ORSMSX105.amr.corp.intel.com>
References: <500FB9C2.1030103@hitachi.com>
In-Reply-To: <500FB9C2.1030103@hitachi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.3.86.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomoki wrote:
> In current Linux, percpu variable `vector_irq' is not always cleared when
> a CPU is offlined. If the cpu that has the disabled irqs in vector_irq is
> hotplugged again, __setup_vector_irq() hits invalid irq vector and may
> crash.
>
> Commit f6175f5bfb4c partially fixes this, but was not enough in
> environments with IOMMU IRQ remapper.

So, this patch essentially makes the commit f6175f5bfb4c unnecessary, right?

Can you revert that too as part of this new proposed patch?

thanks,
suresh