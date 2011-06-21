Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab1FUHaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 03:30:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:63110 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110Ab1FUHaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 03:30:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,399,1304319600"; 
   d="scan'208";a="18723380"
Message-ID: <4E004880.4030000@intel.com>
Date: Tue, 21 Jun 2011 15:30:08 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110510 Iceowl/1.0b2 Icedove/3.1.10
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 1/4] ACPI, APEI, GHES, Prevent GHES to be built as module
References: <1308640587-24502-1-git-send-email-ying.huang@intel.com> <1308640587-24502-2-git-send-email-ying.huang@intel.com> <20110621072301.GA3263@one.firstfloor.org>
In-Reply-To: <20110621072301.GA3263@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andi,

Thanks for comments!

On 06/21/2011 03:23 PM, Andi Kleen wrote:
> On Tue, Jun 21, 2011 at 03:16:24PM +0800, Huang Ying wrote:
>> GHES (Generic Hardware Error Source) is used to process hardware error
>> notification in firmware first mode.  But because firmware first mode
>> can be turned on but can not be turned off, it is unreasonable to
>> unload the GHES module with firmware first mode turned on.  To avoid
>> confusion, this patch makes GHES can be enable/disable in
>> configuration time, but not built as module and unload at run time.
> 
> It's better to keep it as a module, but disable unloading.
> You can do that with a __module_get(THIS_MODULE) in the init code
> when FFM is detected.

There are two ways to turn on firmware first mode

1) APEI bit in generic _OSC call
2) Special APEI _OSC call

1) is run before GHES module loading.  If keeping GHES as a module, it
is possible that firmware first mode has been turned on with APEI bit in
generic _OSC call, but GHES module is prevented to be loaded via some
kind of module blacklist.  So I think it is better to prevent GHES to be
built as module.

Best Regards,
Huang Ying
