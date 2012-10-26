Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656Ab2JZMhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 08:37:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:56159 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932607Ab2JZMhw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 08:37:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,654,1344236400"; 
   d="scan'208";a="232899605"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Jan Beulich <jbeulich@suse.com>
CC: "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: RE: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Thread-Topic: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Thread-Index: AQHNs3G2Ti91BiFLfUibRvXA4zlK85fLgkyg
Date: Fri, 26 Oct 2012 12:37:36 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335372883@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233537157F@SHSMSX101.ccr.corp.intel.com>
	<5089676602000078000A4928@nat28.tlf.novell.com>
	<DE8DF0795D48FD4CA783C40EC82923353723C7@SHSMSX101.ccr.corp.intel.com>
 <508A89CB020000780008E6ED@nat28.tlf.novell.com>
In-Reply-To: <508A89CB020000780008E6ED@nat28.tlf.novell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

-----Original Message-----
From: xen-devel-bounces@lists.xen.org [mailto:xen-devel-bounces@lists.xen.org] On Behalf Of Jan Beulich
Sent: Friday, October 26, 2012 8:02 PM
To: Liu, Jinsong
Cc: konrad.wilk@oracle.com; linux-kernel@vger.kernel.org; xen-devel@lists.xen.org
Subject: Re: [Xen-devel] [PATCH 1/2] Xen acpi pad implement

>>> "Liu, Jinsong" <jinsong.liu@intel.com> 10/26/12 8:18 AM >>>
>> +static struct acpi_driver xen_acpi_pad_driver = {
>> +    .name = "processor_aggregator",
>> +    .class = ACPI_PROCESSOR_AGGREGATOR_CLASS,
>> +    .ids = pad_device_ids,
>> +    .ops = {
>> +        .add = xen_acpi_pad_add,
>
>.remove?
>
>[Jinsong] .remove method not used by any logic now (any possible point use it?), so we remove it from our former patch.

Unless there is technical difficulty implementing it, I wouldn't defer adding that code until the point where something doesn't work anymore.

[Jinsong] No technical difficulty at all, in fact at last version it has .remove method. I will re-add it.

>Overall I'd recommend taking a look at the cleaned up driver in
>our kernels.
>
>[Jinsong] What's your point here?

There's quite a bit of cleanup/simplification potential here, and rather than pointing the pieces out individually I would think comparing with what we have in production use might be worthwhile. But that's up to you of course.

[Jinsong] I know your concern now -- we can cleanup/simplify xen pad logic by piggyback on native acpi pad code -- technically it's true. However, we intentionally do so in order to keep xen pad logic self-contained, just like what xen mcelog logic did before.

Thanks,
Jinsong