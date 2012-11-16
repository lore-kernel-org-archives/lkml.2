Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab2KPD1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 22:27:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:51994 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab2KPD1b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 22:27:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,261,1352102400"; 
   d="scan'208";a="220409861"
From: "Moore, Robert" <robert.moore@intel.com>
To: Ethan Zhao <ethan.kernel@gmail.com>
CC: "Brown, Len" <len.brown@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH ] tbfadt.c: output warning only when 64bit 32bit address
 of FACS/DSDT all have value but not equal to each other
Thread-Topic: [PATCH ] tbfadt.c: output warning only when 64bit 32bit
 address of FACS/DSDT all have value but not equal to each other
Thread-Index: AQHNwU9vBp/XM+1UtU6pHwxKNmNA4pfn8ltggARVVAD//4iUMA==
Date: Fri, 16 Nov 2012 03:27:25 +0000
Message-ID: <94F2FBAB4432B54E8AACC7DFDE6C92E346BDBE51@ORSMSX101.amr.corp.intel.com>
References: <CABawtvMsrMhGL7emsvYRXrGEB9f2Pzha2+XTVSHaYw1PVJGa-Q@mail.gmail.com>
	<94F2FBAB4432B54E8AACC7DFDE6C92E346BC0674@ORSMSX101.amr.corp.intel.com>
 <CABawtvPNmOzgvsg9+y12a5ToCmV4OgKQeBAVQeRyc0F+XWmb7Q@mail.gmail.com>
In-Reply-To: <CABawtvPNmOzgvsg9+y12a5ToCmV4OgKQeBAVQeRyc0F+XWmb7Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Basically, the flow goes like this:

1) We convert the original FADT (multiple versions) to a common internal FADT.
2) Then we check the common internal FADT for errors/inconsistencies.

In this way, we don't need to have different error checking for different versions of the FADT, and this is probably not going to change.

One thing we are going to add is to make a decision on whether to favor a 32-bit address or a 64-bit address (if they are different) based upon the age of the machine/BIOS. This is for Windows compatibility.

Bob


> -----Original Message-----
> From: Ethan Zhao [mailto:ethan.kernel@gmail.com]
> Sent: Thursday, November 15, 2012 6:29 PM
> To: Moore, Robert
> Cc: Brown, Len; Zheng, Lv; LKML
> Subject: Re: [PATCH ] tbfadt.c: output warning only when 64bit 32bit
> address of FACS/DSDT all have value but not equal to each other
> 
> Bob,
>        Thanks for your detailed reviewing about the whole possible
> conditions.
>        I.C.  So that is impossible zero value for Xfacs /Xdsdt if
> facs/dsdt >0, for they are assigned in acpi_tb_convert_fadt(),  I need to
> move my eyes one line code higher to see why it yelled twice but not using
> the 32bit address at once in acpi_tb_convert_fadt().
>        Do you agree to move the checking code warning  and into
> acpi_tb_convert_fadt to make the code more simple and clear ? Or just keep
> it for more rework, more bug?
> 
> 
> Thanks,
> Ethan
