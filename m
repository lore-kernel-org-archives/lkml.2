Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab2KZQXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 11:23:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:11167 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754434Ab2KZQXm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 11:23:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,321,1352102400"; 
   d="scan'208";a="224502827"
From: "Fujinaka, Todd" <todd.fujinaka@intel.com>
To: Joe Jin <joe.jin@oracle.com>, "Dave, Tushar N" <tushar.n.dave@intel.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "e1000-devel@lists.sf.net" <e1000-devel@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mary Mcgrath <mary.mcgrath@oracle.com>
Subject: RE: [E1000-devel] 82571EB: Detected Hardware Unit Hang
Thread-Topic: [E1000-devel] 82571EB: Detected Hardware Unit Hang
Thread-Index: AQHNvXnv9zWmKMRSTUSeVhWmoXs8rZfgY6YggAjMYQD//4mJQIAB4wgAgADGiTCABdgxAIABQf3QgADSdICACRkUUA==
Date: Mon, 26 Nov 2012 16:23:40 +0000
Message-ID: <9B4A1B1917080E46B64F07F2989DADD62F2D62D6@ORSMSX102.amr.corp.intel.com>
References: <509B5038.8090304@oracle.com>
	<061C8A8601E8EE4CA8D8FD6990CEA89133487884@ORSMSX102.amr.corp.intel.com>
	<50A30656.6090508@oracle.com>
	<061C8A8601E8EE4CA8D8FD6990CEA8913348B105@ORSMSX102.amr.corp.intel.com>
	<50A43828.6000702@oracle.com>
	<061C8A8601E8EE4CA8D8FD6990CEA8913349A0B4@ORSMSX102.amr.corp.intel.com>
	<50A9C5CC.1030300@oracle.com>
	<061C8A8601E8EE4CA8D8FD6990CEA8913349EB41@ORSMSX102.amr.corp.intel.com>
 <50AB8471.7080607@oracle.com>
In-Reply-To: <50AB8471.7080607@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2012, Joe Jin wrote:

> On 11/20/12 16:59, Dave, Tushar N wrote:
>> Have you power off the system completely after modifying eeprom? If not please do so.
>
> Hi Tushar,
>
> Seems not works for me, would you please help to check what is wrong of my operations?

...

> # lspci -s 0000:52:00.1 -vvv
> 52:00.1 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (rev 06)
> <--snip-->
>       Capabilities: [e0] Express (v1) Endpoint, MSI 00
>               DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
                ^^^^^^^^^^^^^^^^^^^^
>                       ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
>               DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
>                       RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                       MaxPayload 128 bytes, MaxReadReq 4096 bytes
>           ^^^^^^^^^^^^^^^^^^^^^
>
 <--snip-->

If you look at the previous section, DevCap, you'll see that it's
correctly advertising 256 bytes but the system is negotiating 128 for
the link to the Ethernet controller. Things on the "other" side of the
link are controlled outside of the e1000 driver.

Tushar's first suggestion was to check the PCIe payload settings in the
entire chain. Have you done that? Mismatches will cause hangs.

Todd Fujinaka
Technical Marketing Engineer
LAN Access Division (LAD)
Intel Corporation
todd.fujinaka@intel.com
(503) 712-4565

