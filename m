Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab2LCUCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 15:02:45 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:37308 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab2LCUCn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 15:02:43 -0500
From: "Ortiz, Lance E" <lance.oritz@hp.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "bhelgaas@google.com" <bhelgaas@google.com>,
        "lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 1/3] aerdrv: Trace Event for AER
Thread-Topic: [PATCH v3 1/3] aerdrv: Trace Event for AER
Thread-Index: AQHNz7gRDx2yz86yDEOYhpMK9R3d+JgHgIAA
Date: Mon, 3 Dec 2012 20:01:46 +0000
Message-ID: <A961433CDFF2F640A2866803152E61F9516EE717@G4W3218.americas.hpqcorp.net>
References: <20121130213330.7649.51101.stgit@grignak.americas.hpqcorp.net>
 <20121201093614.720aa96a@redhat.com>
In-Reply-To: <20121201093614.720aa96a@redhat.com>
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
> 
> Hmm... isn't something missing here? I'm seeing more bits defined at
> the
> PCIe V3.0 spec for Offset 10h:
> 
> bit 14 - Corrected Internal Error
> bit 15 - Header Log Overflow
> 
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
> Hmm... isn't something missing here? I'm seeing more bits defined at
> the
> PCIe V3.0 spec for Offset 04h:
> 
> bit 5 - Surprise Down Error
> bit 21 - ACS Violation
> bit 22 - Uncorrectable Internal Error
> bit 23 - MC Blocked TLP
> bit 24 - AtomicOp Egress Blocked
> bit 25 - TLP Prefix Blocked Error
> 

I used the same errors defined in the string arrays at the top of aerdrv_errprint.c.  I am not sure why they were left out in that file.  I will investigate and probably add them as a later patch and then include them in aerdrv_errprint.c also.

Sound good?

Lance

