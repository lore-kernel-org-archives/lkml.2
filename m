Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab1AFVah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 16:30:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:17344 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915Ab1AFVag convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 16:30:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,285,1291622400"; 
   d="scan'208";a="694336650"
From: "Gorby, Russ" <russ.gorby@intel.com>
To: Alan Cox <alan@linux.intel.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "segoon@openwall.com" <segoon@openwall.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ahmed, Suhail" <suhail.ahmed@intel.com>
Date: Thu, 6 Jan 2011 13:30:33 -0800
Subject: RE: [PATCH 4/7] serial: ifx6x60: set SPI max_speed_hz based on
 platform type
Thread-Topic: [PATCH 4/7] serial: ifx6x60: set SPI max_speed_hz based on
 platform type
Thread-Index: AcutO+Fn+HQo56mvSQ2z86EokGPndwAqM+Nw
Message-ID: <4C5E6457CD7911469A07260381288C28CB7E0263@orsmsx502.amr.corp.intel.com>
References: <[PATCH 0/7] IFX6X60 patchset: 01/05/2011>
	<1294272313-15899-5-git-send-email-russ.gorby@intel.com>
 <20110106002716.06a396c7@bob.linux.org.uk>
In-Reply-To: <20110106002716.06a396c7@bob.linux.org.uk>
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

>-----Original Message-----
>From: Alan Cox [mailto:alan@linux.intel.com]
>Sent: Wednesday, January 05, 2011 4:27 PM
>To: Gorby, Russ
>Cc: gregkh@suse.de; segoon@openwall.com; Gorby, Russ; linux-
>kernel@vger.kernel.org; Ahmed, Suhail
>Subject: Re: [PATCH 4/7] serial: ifx6x60: set SPI max_speed_hz based on
>platform type
>
>> +	if (ifx_dev->is_6160)
>> +		spi->max_speed_hz = 12500000;
>> +	else
>> +		spi->max_speed_hz = 25000000;
>
>This should be coming directly from the platform data, ditto I suspect
>wiring the DMA to is_6160 should probably be a platform "use_dma"
>field ?
[Gorby, Russ]
OK I agree for the max clock rate, but I'm not so sure about the "use_dma" case.

Use_dma is used so the protocol driver matches the expectations (capabilities) of the controller driver it attaches to. In the general case I would think it could support several different controller drivers that might have differing capabilities. Currently the driver does assume the value of use_dma is constant for a platform so putting this indication in the platform data would suffice (for now) but to me, this is not really a platform attribute.
Is there a better way to handle this is?


