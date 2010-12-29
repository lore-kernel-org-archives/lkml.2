Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab0L2QTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 11:19:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:60051 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345Ab0L2QTb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 11:19:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,245,1291622400"; 
   d="scan'208";a="588100888"
From: "Gorby, Russ" <russ.gorby@intel.com>
To: "Dan Carpenter " <IMCEAMAILTO-error27+40gmail+2Ecom@intel.com>
CC: "Cox, Alan" <alan.cox@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 29 Dec 2010 08:19:30 -0800
Subject: RE: smatch stuff: serial: ifx6x60: oops on load
Thread-Topic: smatch stuff: serial: ifx6x60: oops on load
Thread-Index: AcugJqrX5fJlqy2PQMmWSeGMkq+ukgAMuVjAAAI3J4AABKf50AAAFLNAAb9GzIA=
Message-ID: <4C5E6457CD7911469A07260381288C28CB5F5F85@orsmsx502.amr.corp.intel.com>
References: <4C5E6457CD7911469A07260381288C28CB379310@orsmsx502.amr.corp.intel.com>
 <E1A1564674E5754FB00AB9AC949D5E3260EB004322@rrsmsx501.amr.corp.intel.com>
 <72D8A09E39A89147BE9CFBB6F0C73C3061F523A532@rrsmsx501.amr.corp.intel.com>
 <E1A1564674E5754FB00AB9AC949D5E3260EB09CDD7@rrsmsx501.amr.corp.intel.com>
In-Reply-To: <E1A1564674E5754FB00AB9AC949D5E3260EB09CDD7@rrsmsx501.amr.corp.intel.com>
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


Yes, unfortunately there are a few issues with this driver that prevent it from loading and running properly.
I will be proving follow-on patches to address this and other issues that have been discovered that should address this. 

>>-----Original Message-----
>>From: Dan Carpenter [mailto:error27@gmail.com]
>>Sent: Monday, December 20, 2010 1:16 AM
>>To: Gorby, Russ
>>Cc: Alan Cox; linux-kernel@vger.kernel.org
>>Subject: smatch stuff: serial: ifx6x60: oops on load
>>
>>Smatch complains that the ifx6x60 driver in linux-next has a NULL
>>dereference.
>>
>>drivers/serial/ifx6x60.c +986 ifx_spi_spi_probe(27)
>>	error: potential null derefence 'pl_data'.
>>
>>   984          ifx_dev->spi_timer.function = ifx_spi_timeout;
>>   985          ifx_dev->spi_timer.data = (unsigned long)ifx_dev;
>>   986          ifx_dev->is_6160 = pl_data->is_6160;
>>                                   ^^^^^^^
>>"pl_data" is always NULL at this point.  Presumably this crashes on
>load
>>every time.
>>
>>regards,
>>dan carpenter

