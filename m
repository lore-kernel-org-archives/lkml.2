Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975Ab0GTWvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 18:51:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59387 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932925Ab0GTWvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 18:51:20 -0400
Message-ID: <4C46285B.2060605@zytor.com>
Date: Tue, 20 Jul 2010 15:51:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/10] x86, xsave: check cpuid level for XSTATE_CPUID
 (0x0d)
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com>	 <1279651857-24639-10-git-send-email-robert.richter@amd.com> <1279664764.2899.54.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1279664764.2899.54.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2010 03:26 PM, Suresh Siddha wrote:
> On Tue, 2010-07-20 at 11:50 -0700, Robert Richter wrote:
>> The patch adds a check that tests if XSTATE_CPUID exists.
>>
>> Signed-off-by: Robert Richter <robert.richter@amd.com>
> 
> While we are at this, can you please rename the other hardcoded 0xd's
> with XSTATE_CPUID in xsave.c?
> 
>> + struct cpuinfo_x86 *c = &cpu_data(0);
> 
> Can we use boot_cpu_data instead of cpu_data(0).
> 

I think boot_cpu_data is the right thing for the early stuff like this
(early_cpu_init() initializes boot_cpu_data, not cpu_data(0)) so just
use boot_cpu_data.cpuid_level instead of forming a pointer.

	-hpa
