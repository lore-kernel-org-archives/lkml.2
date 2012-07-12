Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747Ab2GLCXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 22:23:17 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47674 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481Ab2GLCXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 22:23:16 -0400
Message-ID: <4FFE3505.8060407@oracle.com>
Date: Thu, 12 Jul 2012 10:23:01 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Dave, Tushar N" <tushar.n.dave@intel.com>
CC: "e1000-devel@lists.sf.net" <e1000-devel@lists.sf.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 82571EB: Detected Hardware Unit Hang
References: <4FFA9B96.6040901@oracle.com> <4FFBDC50.5090800@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA891274EE41F@ORSMSX102.amr.corp.intel.com> <4FFCCA22.8060006@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA891274EEC8B@ORSMSX102.amr.corp.intel.com> <4FFCDA6C.8020708@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA891274EED74@ORSMSX102.amr.corp.intel.com> <4FFCF314.6020400@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA891274EEDD7@ORSMSX102.amr.corp.intel.com> <4FFD0908.6080506@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA891274EF8AD@ORSMSX102.amr.corp.intel.com>
In-Reply-To: <061C8A8601E8EE4CA8D8FD6990CEA891274EF8AD@ORSMSX102.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/12 02:51, Dave, Tushar N wrote:
> 
> Joe,
> 
> I see couple of errors in lspci output.
> Device capability status register shows UnCorrectable PCIe error. This means there is certainly something went wrong. The only way to recover from Uncorrectable errors is reset.
>    
> 	DevSta:	CorrErr- *UncorrErr+ FatalErr+ UnsuppReq+ AuxPwr+ TransPend-
> 
> Also AER sections in lspci output shows PCIe completion timeout.
> 	
> 	Capabilities: [100 v1] Advanced Error Reporting
> 		UESta:	DLP- SDES- TLP- FCP- *CmpltTO+ CmpltAbrt- UnxCmplt- RxOF- MalfTLP+ ECRC- UnsupReq+ ACSViol-
> 
> I suggest you should load AER driver and check for any error messages in log. Also please check any error message reported by system in BIOS log. Are there any machine check errors? 
> 
> When did you notice this issue? have 82571 ever been working before on this server?
> 
> One more thing, Cache line size 256 is little unusual( I never seen this value before, mostly it's 64). Does BIOS settings have been changed? Are you using default BIOS setting?
> 

I checked BIOS's log found the fault from the device, I changed "PCI-E Payload Size"
from 256(default) to 128, now the device works.

I compared lspci output found Address for data of MSI Capabilities's be changed:

Old:
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee21000  Data: 40cb

New:
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee24000  Data: 405c

Mostly like it's a BIOS bug? please comments.

Thanks,
Joe

