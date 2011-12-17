Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760744Ab1LQCCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 21:02:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:33662 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150Ab1LQCCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 21:02:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="87515340"
Subject: Re: [PATCH -v8] x86: Disable x2apic if nox2apic is specified or
 intr-remap can not be enabled
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 16 Dec 2011 18:07:03 -0800
In-Reply-To: <1324083546-1003-1-git-send-email-yinghai@kernel.org>
References: <1324083546-1003-1-git-send-email-yinghai@kernel.org>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1324087625.1984.296.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 16:59 -0800, Yinghai Lu wrote:
> For
> 1. x2apic preenabled system
> 2. first kernel have x2apic enabled, and try to kexec second kernel with "nox2apic"
> 
> Will put back cpu with apic id < 255 into xapic mode, instead of panic.
> 

Yinghai, I didn't get a chance to review this patch completely. But few
things.

a. Need to split this patch into multiple patches, specially the cpuid
mechanism to get the initial apic id, flat_probe etc. While I understand
the reason behind the flat_probe change, it isn't quite obvious from
this changelog.

b. for nox2apic, as you try to disable x2apic even if the bios has
enabled it along with interrupt-remapping, this will probably not work
unless we disable interrupt-remapping. So either we need to ignore the
nox2apic when OS can find that interrupt-remapping is already enabled or
disable interrupt-remapping. Let me think a bit more about this and get
back to you by monday with detailed review of this.

thanks,
suresh

