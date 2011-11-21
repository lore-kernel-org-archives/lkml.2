Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab1KUAnw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 19:43:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:11701 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566Ab1KUAnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 19:43:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,544,1315206000"; 
   d="scan'208";a="87557790"
Message-ID: <1321836227.13860.121.camel@yhuang-dev>
Subject: RE: [RFC][PATCH]ACPI,APEI,ERST, back end driver for NVRAM
From: Huang Ying <ying.huang@intel.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, "Chen, Gong" <gong.chen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Mon, 21 Nov 2011 08:43:47 +0800
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C57B4FA66@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C57AC8046@USINDEVS01.corp.hds.com>
	 <1321581563.13860.111.camel@yhuang-dev>
	 <5C4C569E8A4B9B42A84A977CF070A35B2C57B4FA66@USINDEVS01.corp.hds.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-11-19 at 07:04 +0800, Seiji Aguchi wrote:
> Hi,
> 
> >According to ACPI 4.0a spec:
> >
> >"""
> >17.5.2.4.1 Error Log Address Range Resides in NVRAM
> >
> 
> Thank you for giving me the information.
> Let me clarify one thing.
> 
> If the busy bit can be cleared immediately, we don't need to
> check busy bit with CHECK_BUSY_STATUS.
> So, we should simply execute OSPM operations as follows.
> 
>  - Writing
>    1. BEGIN_WRITE
>    2. SET_RECORD_OFFSET
>    3. EXECUTE_OPERATION
>    4. END
> 
>  - Reading
>    1. BEGIN_READ
>    2. SET_RECORD_OFFSET
>    3. SET_RECORD_ID
>    4. EXECUTE_OPERATION
>    (END operation is not needed because OSPM requires no platform 
>     support to read.)
> 
>  - Clearing
>    1. BEGIN_CLEAR
>    2. SET_RECORD_ID
>    3. EXECUTE_OPERATION
>    (END operation is not needed because OSPM requires no platform 
>     support to clear.)
> 
> Is this what you expected?

No.  I have different understanding.

Because error log address range resides in NVRAM, the contents will be
reserved even after reboot.  So we do not need read/clear operations at
all, and should place all records in error log address range.

Best Regards,
Huang Ying


