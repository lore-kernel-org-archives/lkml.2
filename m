Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab1AJTTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 14:19:47 -0500
Received: from mga03.intel.com ([143.182.124.21]:1767 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab1AJTTo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 14:19:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,302,1291622400"; 
   d="scan'208";a="372507059"
From: "Heasley, Seth" <seth.heasley@intel.com>
To: Jean Delvare <khali@linux-fr.org>
CC: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Date: Mon, 10 Jan 2011 11:19:15 -0800
Subject: RE: [PATCH 2.6.37] irq: irq and pci_ids patch for Intel DH89xxCC
 DeviceIDs
Thread-Topic: [PATCH 2.6.37] irq: irq and pci_ids patch for Intel DH89xxCC
 DeviceIDs
Thread-Index: Acuw+rNbjELsWxTqQFS60Bg0+y9bhAAAEWKw
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25C1AF9090@orsmsx501.amr.corp.intel.com>
References: <201101101058.13515.seth.heasley@intel.com>
 <20110110201430.7ab599c4@endymion.delvare>
In-Reply-To: <20110110201430.7ab599c4@endymion.delvare>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> --- linux-2.6.37/arch/x86/pci/irq.c.orig	2011-01-04
>16:50:19.000000000 -0800
>> +++ linux-2.6.37/arch/x86/pci/irq.c	2011-01-06 14:16:00.000000000
>-0800
>> @@ -611,6 +611,15 @@
>>  		r->set = pirq_piix_set;
>>  		return 1;
>>  	}
>> +
>> +	if ((device >= PCI_DEVICE_ID_INTEL_DH89XXCC_LPC_MIN) &&
>> +		(device <= PCI_DEVICE_ID_INTEL_DH89XXCC_LPC_MAX)) {
>> +		r->name = "PIIX/ICH";
>> +		r->get = pirq_piix_get;
>> +		r->set = pirq_piix_set;
>> +		return 1;
>> +	}
>> +
>
>I'm curious why we have separate sections for INTEL_5_3400_SERIES,
>INTEL_COUGARPOINT and now INTEL_DH89XXCC? We do the same thing for all
>3, so it would make sense to merge the tests to avoid duplicating the
>code.

Some products are defining a range of DeviceIDs rather than one or two specific IDs, so these blocks are for catching any DeviceID in the range.  I'm certainly open to suggestion for a better way to handle these, and I agree that the current way is awkward.

-Seth  
