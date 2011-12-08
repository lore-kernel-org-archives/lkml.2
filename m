Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab1LHS3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 13:29:47 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58549 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab1LHS3p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 13:29:45 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1750B77A7E@HQMAIL01.nvidia.com>
References: <1323348254-29072-1-git-send-email-pdeschrijver@nvidia.com>
	<1323348254-29072-5-git-send-email-pdeschrijver@nvidia.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1750B77A7E@HQMAIL01.nvidia.com>
Date: Thu, 8 Dec 2011 10:29:43 -0800
X-Google-Sender-Auth: 6E__HLdc3fmXio7Ju8tVSbaFENk
Message-ID: <CAMbhsRTD1rQBY7Sn2km=XsUYsHMdqQqZSKu4agc0GB6+QE79fA@mail.gmail.com>
Subject: Re: [PATCH v6 04/10] arm/tegra: prepare early init for multiple tegra variants
From: Colin Cross <ccross@android.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Gary King <gking@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 8, 2011 at 9:57 AM, Stephen Warren <swarren@nvidia.com> wrote:
> Peter De Schrijver wrote at Thursday, December 08, 2011 5:44 AM:
>> This patch splits the early init code in a common and a tegra20 specific part.
>> L2 cache initialization is generalized and discovers the cache associativity
>> at runtime. Also use arm_pm_restart instead of arm_arch_reset and reset the
>> the system using the PMC reset feature rather then the CAR system reset.
>
> This one really should be at least 3 separate patches:
> * s/tegra_init_early/tegra20_init_early/ in machine descriptions
> * Switch reset mechanism from CAR to PMC
> * tegra_init_cache modifications
> * Not sure if all the ifdef additions go in the above, or if some should be
>  separate?
>
> Still, I think it's probably OK to go in as it is even if it isn't optimal.

Please at least split out the reset change.  Does using the PMC reset
instead of the CAR reset still result in a warm reset, or does it
change to a cold reset?
