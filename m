Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab1HCXMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:12:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:38965 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570Ab1HCXMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:12:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,312,1309762800"; 
   d="scan'208";a="37642107"
Message-ID: <4E39D5DF.6010104@linux.intel.com>
Date: Wed, 03 Aug 2011 16:12:31 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@linux.intel.com>,
        Jan Beulich <JBeulich@novell.com>, Matthew Garrett <mjg@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH] x86, efi: Don't recursively acquire rtc_lock
References: <1312405454-29386-1-git-send-email-matt@console-pimps.org>
In-Reply-To: <1312405454-29386-1-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2011 02:04 PM, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@linux.intel.com>
> 
> A deadlock was introduced on x86 in commit ef68c8f87ed1 ("x86:
> Serialize EFI time accesses on rtc_lock") because efi_get_time() and
> friends can be called with rtc_lock already held by
> read_persistent_time(), e.g.
> 
> timekeeping_init()
>     read_persistent_clock()	<-- acquire rtc_lock
>         efi_get_time()
>             phys_efi_get_time()	<-- acquire rtc_lock <DEADLOCK>
> 
> Move the locking up into the caller of efi.get_time() and provide some
> wrappers for use in other parts of the kernel instead of calling
> efi.get_time(), etc directly. This way we can hide the rtc_lock dance
> inside of arch/x86.
> 
> Cc: Jan Beulich <JBeulich@novell.com>
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: "H. Peter Anvin" <hpa@linux.intel.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>

For the x86 footprint:

Acked-by: H. Peter Anvin <hpa@linux.intel.com>
