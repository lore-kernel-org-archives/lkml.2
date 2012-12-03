Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab2LCUVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 15:21:20 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:29326 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab2LCUVS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 15:21:18 -0500
From: "Ortiz, Lance E" <lance.oritz@hp.com>
To: Joe Perches <joe@perches.com>
CC: "bhelgaas@google.com" <bhelgaas@google.com>,
        "lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 1/3] aerdrv: Trace Event for AER
Thread-Topic: [PATCH v4 1/3] aerdrv: Trace Event for AER
Thread-Index: AQHN0Y+XW9X0YAlVw0GID3XVvKQIGpgHg77w
Date: Mon, 3 Dec 2012 20:20:22 +0000
Message-ID: <A961433CDFF2F640A2866803152E61F9516EE733@G4W3218.americas.hpqcorp.net>
References: <20121203183305.26636.22979.stgit@grignak.americas.hpqcorp.net>
 <1354564292.3524.7.camel@joe-AO722>
In-Reply-To: <1354564292.3524.7.camel@joe-AO722>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +#define correctable_error_string			\
> > +	{BIT(0),	"Receiver Error"},		\
> > +	{BIT(6),	"Bad TLP"},			\
> > +	{BIT(7),	"Bad DLLP"},			\
> > +	{BIT(8),	"RELAY_NUM Rollover"},		\
> > +	{BIT(12),	"Replay Timer Timeout"},	\
> > +	{BIT(13),	"Advisory Non-Fatal"}
> > +
> > +#define uncorrectable_error_string			\
> > +	{BIT(4),	"Data Link Protocol"},		\
> > +	{BIT(12),	"Poisoned TLP"},		\
> > +	{BIT(13),	"Flow Control Protocol"},	\
> > +	{BIT(14),	"Completion Timeout"},		\
> > +	{BIT(15),	"Completer Abort"},		\
> > +	{BIT(16),	"Unexpected Completion"},	\
> > +	{BIT(17),	"Receiver Overflow"},		\
> > +	{BIT(18),	"Malformed TLP"},		\
> > +	{BIT(19),	"ECRC"},			\
> > +	{BIT(20),	"Unsupported Request"}
> 
> probably better to prefix these with aer_

If I add aer_ it will conflict with string array in aerdrv_errprint.c

> 
> > +	TP_printk("%s PCIe Bus Error: severity=%s, %s\n",
> > +		__get_str(dev_name),
> > +		(__entry->severity == HW_EVENT_ERR_CORRECTED) ? "Corrected"
> :
> > +			((__entry->severity == HW_EVENT_ERR_FATAL) ?
> > +			"Fatal" : "Uncorrected"),
> 
> unnecessary parentheses
> 
> 		__entry->severity == HW_EVENT_ERR_CORRECTED ? "Corrected" :
> 		__entry->severity == HW_EVENT_ERR_FATAL ? "Fatal" :
> 		"Uncorrected"),
> 
> might be more kernel style conventional

Ok I removed them. 

Thanks

Lance

