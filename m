Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab2GZJim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 05:38:42 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:52181 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2GZJik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 05:38:40 -0400
X-AuditID: b753bd60-a0885ba000000655-b9-5011101ed996
X-AuditID: b753bd60-a0885ba000000655-b9-5011101ed996
Message-ID: <50111029.6040408@hitachi.com>
Date: Thu, 26 Jul 2012 18:38:49 +0900
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: suresh.b.siddha@intel.com
Cc: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com, yinghai@kernel.org,
        agordeev@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH] x86/ioapic: Fix NULL pointer dereference on CPU hotplug
 after disabling irqs
References: <500FB9C2.1030103@hitachi.com> <BC5CD145C5D9E74D86490E60F52766FF1EBCFCDD@ORSMSX105.amr.corp.intel.com>
In-Reply-To: <BC5CD145C5D9E74D86490E60F52766FF1EBCFCDD@ORSMSX105.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, thanks for your comment.

On 2012/07/26 8:28, Siddha, Suresh B wrote:
> Tomoki wrote:
>> In current Linux, percpu variable `vector_irq' is not always cleared when
>> a CPU is offlined. If the cpu that has the disabled irqs in vector_irq is
>> hotplugged again, __setup_vector_irq() hits invalid irq vector and may
>> crash.
>>
>> Commit f6175f5bfb4c partially fixes this, but was not enough in
>> environments with IOMMU IRQ remapper.
> 
> So, this patch essentially makes the commit f6175f5bfb4c unnecessary, right?
> 
> Can you revert that too as part of this new proposed patch?
> 
> thanks,
> suresh

OK, I will include a reverse patch of f6175f5bfb4c and resend the patch.

Thanks,
-- 
Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory

