Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab2LCVOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 16:14:48 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:15459 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab2LCVOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 16:14:45 -0500
From: "Ortiz, Lance E" <lance.oritz@hp.com>
To: Borislav Petkov <bp@alien8.de>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhang Yanmin <yanmin.zhang@intel.com>
Subject: RE: [PATCH v3 1/3] aerdrv: Trace Event for AER
Thread-Topic: [PATCH v3 1/3] aerdrv: Trace Event for AER
Thread-Index: AQHNz7gRDx2yz86yDEOYhpMK9R3d+JgHifsZgAAFv2A=
Date: Mon, 3 Dec 2012 21:13:49 +0000
Message-ID: <A961433CDFF2F640A2866803152E61F9516EE7B0@G4W3218.americas.hpqcorp.net>
References: <20121130213330.7649.51101.stgit@grignak.americas.hpqcorp.net>
 <20121201093614.720aa96a@redhat.com>
 <A961433CDFF2F640A2866803152E61F9516EE717@G4W3218.americas.hpqcorp.net>
 <20121203202756.GB14798@liondog.tnic>
In-Reply-To: <20121203202756.GB14798@liondog.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.25]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qB3LEpLE005440

> 
> Maybe we should ask Yanmin who added those strings in
> 6c2b374d74857e892080ee726184ec1d15e7d4e4; CCed.
> 
> Also, it would make a lot of sense to have those string definitions
> at one place and then reuse them instead of define them again in the
> tracepoint header and they get out of sync and have needless
> duplication
> in the kernel, etc, etc.
> 
> So, instead, you could define some macros which can generate your
> strings above like this:
> 
> #define aer_uncor_err_str(bitnum)	\
> 	{ BIT(bitnum), aer_uncorrectable_error_string(bitnum) }
> 
> and use that macro for the __print_flags flag_array argument.
> 
> Or something to that effect.
> 
> Even better would it be if the error strings in
> <drivers/pci/pcie/aer/aerdrv_errprint.c> could be shared with the
> tracepoint ones. That would require a bit more changes though but
> something like using an array of trace_print_flags instead an array of
> strings could be doable.
> 
> Then, when you need the string, you do uncor_err_array[i].name and so
> on.

This a fine idea.  I'm thinking we might want to implement that in a later patch since it is a bigger change and we still need to see about adding additional strings.  I can send out one more version of the patch with the comment header changes you suggested, and the comments Joe had and maybe we can move forward with that.

Lance 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
