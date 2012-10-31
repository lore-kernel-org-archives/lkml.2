Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760781Ab2JaVB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 17:01:58 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:49600 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760591Ab2JaVB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 17:01:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Zheng, Lv" <lv.zheng@intel.com>, "Huang, Ying" <ying.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        x86 list <x86@kernel.org>
Subject: Re: [PATCH 1/5] driver core / ACPI: Move ACPI support to core device and driver types
Date: Wed, 31 Oct 2012 22:06 +0100
Message-ID: <4946697.LIFggnbCY6@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19D5B8C0@ORSMSX108.amr.corp.intel.com>
References: <1421417.rIOjExM5Pt@vostro.rjw.lan> <1789657.7GoIl2rp8v@vostro.rjw.lan> <3908561D78D1C84285E8C5FCA982C28F19D5B8C0@ORSMSX108.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 31, 2012 08:33:53 PM Luck, Tony wrote:
> > By "tested" I mean "run with some new devices that use the ACPI enumeration
> > provided here, on x86".  Sorry for being too vague.
> 
> Do you or Mika have access to an ia64 box to test.

I don't.  I'm not sure about Mika.

> If not, can you suggest some way that I could exercise this code w/o the new
> devices. Or at least reassure myself that all is benign in a system full of
> old devices.

There are two parts of the new code, one that's always executed, regardless of
whether or not there are devices using the support provided by this series, and
the other that's executed only for those devices.

All depends on what's there in acpi_platform_device_ids[] (added by patch [5/5]),
which is empty for now (Mika has a separate patch adding some IDs in there).
The second part of the new code will only be run and platform device objects
will only be created by it if there is at least one entry in
acpi_platform_device_ids[] matching a device ID of an ACPI node in the BIOS.

The BIOSes of currently available ia64 systems don't contain ACPI nodes whose
IDs will match the IDs of the new devices (ie. the ones that are going to be
added to acpi_platform_device_ids[]), so for ia64 it should be sufficient to
test that code as is (ie. without any new devices in the system).

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
