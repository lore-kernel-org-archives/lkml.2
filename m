Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab1HCXFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:05:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51318 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570Ab1HCXFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:05:06 -0400
Message-ID: <4E39D400.2080507@zytor.com>
Date: Wed, 03 Aug 2011 16:04:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 1/5] mrst_pmu: driver for Intel Moorestown Power Management
 Unit
References: <1312400648-17636-1-git-send-email-lenb@kernel.org> <8e24ed2af46a5d008d85bfeb128d25efc394a3fd.1312400543.git.len.brown@intel.com>
In-Reply-To: <8e24ed2af46a5d008d85bfeb128d25efc394a3fd.1312400543.git.len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2011 12:44 PM, Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
> 
> The Moorestown (MRST) Power Management Unit (PMU) driver
> directs the SOC power states in the "Langwell" south complex (SCU).
> 
> It hooks pci_platform_pm_ops[] and thus observes all PCI ".set_state"
> requests.  For devices in the SC, the pmu driver translates those
> PCI requests into the appropriate commands for the SCU.
> 
> The PMU driver helps implement S0i3, a deep system idle power idle state.
> Entry into S0i3 is via cpuidle, just like regular processor c-states.
> S0i3 depends on pre-conditions including uni-processor, graphics off,
> and certain IO devices in the SC must be off.  If those pre-conditions
> are met, then the PMU allows cpuidle to enter S0i3, otherwise such requests
> are demoted, either to Atom C4 or Atom C6.
> 
> This driver is based on prototype work by Bruce Flemming,
> Illyas Mansoor, Rajeev D. Muralidhar, Vishwesh M. Rudramuni,
> Hari Seshadri and Sujith Thomas.  The current driver also
> includes contributions from H. Peter Anvin, Arjan van de Ven,
> Kristen Accardi, and Yong Wang.
> 
> Thanks for additional review feedback from Alan Cox and Randy Dunlap.
> 
> Signed-off-by: Len Brown <len.brown@intel.com>
> Acked-by: Alan Cox <alan@linux.intel.com>
> ---
>  MAINTAINERS                     |    6 +
>  arch/x86/platform/mrst/Makefile |    1 +
>  arch/x86/platform/mrst/pmu.c    |  817 +++++++++++++++++++++++++++++++++++++++
>  arch/x86/platform/mrst/pmu.h    |  234 +++++++++++
>  4 files changed, 1058 insertions(+), 0 deletions(-)
>  create mode 100644 arch/x86/platform/mrst/pmu.c
>  create mode 100644 arch/x86/platform/mrst/pmu.h
> 

Acked-by: H. Peter Anvin <hpa@linux.intel.com>

	-hpa

