Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240Ab0GUQcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 12:32:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60425 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758237Ab0GUQcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 12:32:51 -0400
Message-ID: <4C472123.1090900@zytor.com>
Date: Wed, 21 Jul 2010 09:32:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] x86, xsave: some code cleanups and reworks
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com> <20100720192717.GC6227@lenovo> <20100720194606.GO26154@erda.amd.com> <20100720200729.GD6227@lenovo> <20100720201740.GE6227@lenovo>
In-Reply-To: <20100720201740.GE6227@lenovo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2010 01:17 PM, Cyrill Gorcunov wrote:
> 
> well, not true, this id is being set in setup_per_cpu_areas()
> note the snippet
> 
> 		if (cpu == boot_cpu_id)
> 			switch_to_new_gdt(cpu);
> 
> but cycle of assignment is done over all possible cpus so
> smp_processor_id will be = 0 for BP but definitely it's
> confusing and better to check for BP via explicit cpu == boot_cpu_id
> I think. Though I might be missing something.
> 

I think the style (!smp_processor_id()) is already in use in other
places, but we should be consistent in style; if you want to introduce a
new style I certainly agree that (is_boot_cpu()) is pretty clear but it
should be introduced universally.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

