Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab2K0SYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 13:24:37 -0500
Received: from mga01.intel.com ([192.55.52.88]:49028 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756212Ab2K0SYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 13:24:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,328,1352102400"; 
   d="scan'208";a="255209965"
From: "Fujinaka, Todd" <todd.fujinaka@intel.com>
To: Ben Hutchings <bhutchings@solarflare.com>,
        Mary Mcgrath <mary.mcgrath@oracle.com>
CC: Joe Jin <joe.jin@oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "e1000-devel@lists.sf.net" <e1000-devel@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>
Subject: RE: [E1000-devel] 82571EB: Detected Hardware Unit Hang
Thread-Topic: [E1000-devel] 82571EB: Detected Hardware Unit Hang
Thread-Index: AQHNvXnv9zWmKMRSTUSeVhWmoXs8rZfgY6YggAjMYQD//4mJQIAB4wgAgADGiTCABdgxAIABQf3QgADSdICACRkUUIABF0CAgAASxICAAHGIgIAAm8kA//99PMA=
Date: Tue, 27 Nov 2012 18:24:33 +0000
Message-ID: <9B4A1B1917080E46B64F07F2989DADD62F2D8116@ORSMSX102.amr.corp.intel.com>
References: <509B5038.8090304@oracle.com>
	 <061C8A8601E8EE4CA8D8FD6990CEA89133487884@ORSMSX102.amr.corp.intel.com>
	 <50A30656.6090508@oracle.com>
	 <061C8A8601E8EE4CA8D8FD6990CEA8913348B105@ORSMSX102.amr.corp.intel.com>
	 <50A43828.6000702@oracle.com>
	 <061C8A8601E8EE4CA8D8FD6990CEA8913349A0B4@ORSMSX102.amr.corp.intel.com>
	 <50A9C5CC.1030300@oracle.com>
	 <061C8A8601E8EE4CA8D8FD6990CEA8913349EB41@ORSMSX102.amr.corp.intel.com>
	 <50AB8471.7080607@oracle.com>
	 <9B4A1B1917080E46B64F07F2989DADD62F2D62D6@ORSMSX102.amr.corp.intel.com>
	 <50B41077.3080009@oracle.com>
	 <b46b84cf-3688-4fd7-b741-4e96f2663517@default>
	 <9B4A1B1917080E46B64F07F2989DADD62F2D8070@ORSMSX102.amr.corp.intel.com>
 <1354039840.2701.14.camel@bwh-desktop.uk.solarflarecom.com>
In-Reply-To: <1354039840.2701.14.camel@bwh-desktop.uk.solarflarecom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qARIOhP3002422

Thanks for the clarification. I was just going by the PCIe spec, which says the lowest value of both ends is used, and I figured SOMETHING had to be looking at that and doing some sort of negotiation. I'm no BIOS guy, so I'm not sure what's actually going on, whether something walks the PCIe tree or if the BIOS just sets all the values to the minimum.

Todd Fujinaka
Technical Marketing Engineer
LAN Access Division (LAD)
Intel Corporation
todd.fujinaka@intel.com
(503) 712-4565


-----Original Message-----
From: Ben Hutchings [mailto:bhutchings@solarflare.com] 
Sent: Tuesday, November 27, 2012 10:11 AM
To: Fujinaka, Todd; Mary Mcgrath
Cc: Joe Jin; netdev@vger.kernel.org; e1000-devel@lists.sf.net; linux-kernel@vger.kernel.org; linux-pci
Subject: RE: [E1000-devel] 82571EB: Detected Hardware Unit Hang

On Tue, 2012-11-27 at 17:32 +0000, Fujinaka, Todd wrote:
> Forgive me if I'm being too repetitious as I think some of this has 
> been mentioned in the past.
> 
> We (and by we I mean the Ethernet part and driver) can only change the 
> advertised availability of a larger MaxPayloadSize. The size is 
> negotiated by both sides of the link when the link is established. The 
> driver should not change the size of the link as it would be poking at 
> registers outside of its scope and is controlled by the upstream 
> bridge (not us).
[...]

MaxPayloadSize (MPS) is not negotiated between devices but is programmed by the system firmware (at least for devices present at boot - the kernel may be responsible in case of hotplug).  You can use the kernel parameter 'pci=pcie_bus_perf' (or one of several others) to set a policy that overrides this, but no policy will allow setting MPS above the device's MaxPayloadSizeSupported (MPSS).

(These parameters are not documented in
Documentation/kernel-parameters.txt!  Someone ought to fix that.)

Ben.

--
Ben Hutchings, Staff Engineer, Solarflare Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
