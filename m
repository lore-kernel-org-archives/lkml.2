Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab2K1PxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 10:53:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:39739 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754718Ab2K1PxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 10:53:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,179,1355126400"; 
   d="scan'208";a="248581407"
From: "Fujinaka, Todd" <todd.fujinaka@intel.com>
To: Joe Jin <joe.jin@oracle.com>, Ben Hutchings <bhutchings@solarflare.com>
CC: Mary Mcgrath <mary.mcgrath@oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "e1000-devel@lists.sf.net" <e1000-devel@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>
Subject: RE: [E1000-devel] 82571EB: Detected Hardware Unit Hang
Thread-Topic: [E1000-devel] 82571EB: Detected Hardware Unit Hang
Thread-Index: AQHNvXnv9zWmKMRSTUSeVhWmoXs8rZfgY6YggAjMYQD//4mJQIAB4wgAgADGiTCABdgxAIABQf3QgADSdICACRkUUIABF0CAgAASxICAAHGIgIABBjKNgAB6tOA=
Date: Wed, 28 Nov 2012 15:53:00 +0000
Message-ID: <9B4A1B1917080E46B64F07F2989DADD62F2D8AAC@ORSMSX102.amr.corp.intel.com>
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
 <50B5CBD2.5020804@oracle.com>
In-Reply-To: <50B5CBD2.5020804@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qASFrEjE008009

The only EEPROM I know about or can speak to is the one attached to the 82571 and it doesn't set the MaxPayloadSize. That's done by the BIOS.

Todd Fujinaka
Technical Marketing Engineer
LAN Access Division (LAD)
Intel Corporation
todd.fujinaka@intel.com
(503) 712-4565


-----Original Message-----
From: Joe Jin [mailto:joe.jin@oracle.com] 
Sent: Wednesday, November 28, 2012 12:31 AM
To: Ben Hutchings
Cc: Fujinaka, Todd; Mary Mcgrath; netdev@vger.kernel.org; e1000-devel@lists.sf.net; linux-kernel@vger.kernel.org; linux-pci
Subject: Re: [E1000-devel] 82571EB: Detected Hardware Unit Hang

On 11/28/12 02:10, Ben Hutchings wrote:
> On Tue, 2012-11-27 at 17:32 +0000, Fujinaka, Todd wrote:
>> Forgive me if I'm being too repetitious as I think some of this has 
>> been mentioned in the past.
>>
>> We (and by we I mean the Ethernet part and driver) can only change 
>> the advertised availability of a larger MaxPayloadSize. The size is 
>> negotiated by both sides of the link when the link is established. 
>> The driver should not change the size of the link as it would be 
>> poking at registers outside of its scope and is controlled by the 
>> upstream bridge (not us).
> [...]
> 
> MaxPayloadSize (MPS) is not negotiated between devices but is 
> programmed by the system firmware (at least for devices present at 
> boot - the kernel may be responsible in case of hotplug).  You can use 
> the kernel parameter 'pci=pcie_bus_perf' (or one of several others) to 
> set a policy that overrides this, but no policy will allow setting MPS 
> above the device's MaxPayloadSizeSupported (MPSS).
> 

Ben,

Unfortunately I'm using 3.0.x kernel and this is not included in the kernel.
So I'm trying to use ethtool modify it from eeprom to see if help or no.


Todd, I'll review all MaxPayload for all devices, but need to say if it mismatch, customer could not modify it from BIOS for there was not entry at there, to test it, we have to find how to verify if this is the root cause, so still need to find the offset in eeprom.

Thanks in advance,
Joe

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
