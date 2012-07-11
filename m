Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab2GKSv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 14:51:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:26939 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755329Ab2GKSv0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 14:51:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="191387445"
From: "Dave, Tushar N" <tushar.n.dave@intel.com>
To: Joe Jin <joe.jin@oracle.com>
CC: "e1000-devel@lists.sf.net" <e1000-devel@lists.sf.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Dave, Tushar N" <tushar.n.dave@intel.com>
Subject: RE: 82571EB: Detected Hardware Unit Hang
Thread-Topic: 82571EB: Detected Hardware Unit Hang
Thread-Index: AQHNXbA0O4dj/qIKzEaqpnXp2Y+l0pcimGMAgABDhtCAANf7AP//lehggAB9gwD//6IHIIAAe14A//+RAgAAESU+AAANp23A
Date: Wed, 11 Jul 2012 18:51:21 +0000
Message-ID: <061C8A8601E8EE4CA8D8FD6990CEA891274EF8AD@ORSMSX102.amr.corp.intel.com>
References: <4FFA9B96.6040901@oracle.com> <4FFBDC50.5090800@oracle.com>
 <061C8A8601E8EE4CA8D8FD6990CEA891274EE41F@ORSMSX102.amr.corp.intel.com>
 <4FFCCA22.8060006@oracle.com>
 <061C8A8601E8EE4CA8D8FD6990CEA891274EEC8B@ORSMSX102.amr.corp.intel.com>
 <4FFCDA6C.8020708@oracle.com>
 <061C8A8601E8EE4CA8D8FD6990CEA891274EED74@ORSMSX102.amr.corp.intel.com>
 <4FFCF314.6020400@oracle.com>
 <061C8A8601E8EE4CA8D8FD6990CEA891274EEDD7@ORSMSX102.amr.corp.intel.com>
 <4FFD0908.6080506@oracle.com>
In-Reply-To: <4FFD0908.6080506@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Joe Jin [mailto:joe.jin@oracle.com]
>Sent: Tuesday, July 10, 2012 10:03 PM
>To: Dave, Tushar N
>Cc: e1000-devel@lists.sf.net; netdev@vger.kernel.org; linux-
>kernel@vger.kernel.org
>Subject: Re: 82571EB: Detected Hardware Unit Hang
>
>On 07/11/12 12:05, Dave, Tushar N wrote:
>> When you said you had this issue with RHEL5 and RHEL6 drivers, have you
>install RHEl5/6 kernel and reproduced it? If so I think I should install
>RHEL6 and try reproduce it locally!
>>
>Yes I reproduced this on both RHEL5 and RHEL6.
>
>So far I tried to scp big file (~1GB) will hit it at once.
>
>Thanks,
>Joe

Joe,

I see couple of errors in lspci output.
Device capability status register shows UnCorrectable PCIe error. This means there is certainly something went wrong. The only way to recover from Uncorrectable errors is reset.
   
	DevSta:	CorrErr- *UncorrErr+ FatalErr+ UnsuppReq+ AuxPwr+ TransPend-

Also AER sections in lspci output shows PCIe completion timeout.
	
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- *CmpltTO+ CmpltAbrt- UnxCmplt- RxOF- MalfTLP+ ECRC- UnsupReq+ ACSViol-

I suggest you should load AER driver and check for any error messages in log. Also please check any error message reported by system in BIOS log. Are there any machine check errors? 

When did you notice this issue? have 82571 ever been working before on this server?

One more thing, Cache line size 256 is little unusual( I never seen this value before, mostly it's 64). Does BIOS settings have been changed? Are you using default BIOS setting?

Thanks.

-Tushar

  
		


