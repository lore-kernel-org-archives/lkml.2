Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab0FAS5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 14:57:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:46903 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035Ab0FAS5o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 14:57:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,341,1272870000"; 
   d="scan'208";a="626594447"
From: "Williams, Mitch A" <mitch.a.williams@intel.com>
To: Greg KH <greg@kroah.com>, Frank Pan <frankpzh@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Yu Zhao <yu.zhao@intel.com>, Chris Wright <chrisw@sous-sol.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "David S. Miller" <davem@davemloft.net>,
       Matt Carlson <mcarlson@broadcom.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 1 Jun 2010 12:57:18 -0600
Subject: RE: Add a helper function in PCI IOV to get VF device
Thread-Topic: Add a helper function in PCI IOV to get VF device
Thread-Index: AcsBuuYRAsDnk3SAT6agyOw2APIFcwAALeLg
Message-ID: <EA929A9653AAE14F841771FB1DE5A1365FF3EC130E@rrsmsx501.amr.corp.intel.com>
References: <AANLkTimTm57fvumRXo9pegOY2M78mduBsClwYlmAOzpo@mail.gmail.com>
 <20100601183920.GB19955@kroah.com>
In-Reply-To: <20100601183920.GB19955@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: Go8t IIPg NNNm Q0Ke R355 TCwa TYYS u5X/ 8dcY AAL8jA==
 AAv/kw== AAyQ3Q== ACrRbA== ALf9/A== ANlDPQ==
 AOuv9g==;12;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGMAaAByAGkAcwB3AEAAcwBvAHUAcwAtAHMAbwBsAC4AbwByAGcAOwBkAGEAdgBlAG0AQABkAGEAdgBlAG0AbABvAGYAdAAuAG4AZQB0ADsAZgByAGEAbgBrAHAAegBoAEAAZwBtAGEAaQBsAC4AYwBvAG0AOwBnAHIAZQBnAEAAawByAG8AYQBoAC4AYwBvAG0AOwBqAGIAYQByAG4AZQBzAEAAdgBpAHIAdAB1AG8AdQBzAGcAZQBlAGsALgBvAHIAZwA7AGsAYQBuAGUAcwBoAGkAZwBlAC4AawBlAG4AagBpAEAAagBwAC4AZgB1AGoAaQB0AHMAdQAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAHAAYwBpAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBtAGMAYQByAGwAcwBvAG4AQABiAHIAbwBhAGQAYwBvAG0ALgBjAG8AbQA7AHIAagB3AEAAcwBpAHMAawAuAHAAbAA7AHkAdQAuAHoAaABhAG8AQABpAG4AdABlAGwALgBjAG8AbQA=;Sosha1_v1;7;{83083E92-9C78-485F-A2EF-DC09162BE6DB};bQBpAHQAYwBoAC4AYQAuAHcAaQBsAGwAaQBhAG0AcwBAAGkAbgB0AGUAbAAuAGMAbwBtAA==;Tue,
 01 Jun 2010 18:57:18
 GMT;UgBFADoAIABBAGQAZAAgAGEAIABoAGUAbABwAGUAcgAgAGYAdQBuAGMAdABpAG8AbgAgAGkAbgAgAFAAQwBJACAASQBPAFYAIAB0AG8AIABnAGUAdAAgAFYARgAgAGQAZQB2AGkAYwBlAA==
x-cr-puzzleid: {83083E92-9C78-485F-A2EF-DC09162BE6DB}
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Greg KH [mailto:greg@kroah.com]
>Sent: Tuesday, June 01, 2010 11:39 AM


>
>On Tue, Jun 01, 2010 at 01:05:25PM +0800, Frank Pan wrote:
>> Greetings,
>>
>> The motivation is make VF device visible to PF driver. PF driver
>> may need this to access VF's PCI configuration.
>
>What is "VF" and "PF" here?
>
>> Another use case is in sysfs symbolic linking. Some of VF's sysfs
>> entries are created by PF driver. For example, /sys/class/net/ethx/vfx
>> in Intel 82576 NIC driver. Makeing a symbolic link from VF's pci device
>> to this path also must be done in PF's driver.
>
>No, the network core should create that symlink, not the driver, right?
>
>thanks,
>
>greg k-h

Furthermore, the links are already there in sysfs, created by the PCI subsystem. 

/sys/class/net/ethX/device links to the PCI device entry for the PF device, which itself has symlinks to each of the VF devices.

This patch just isn't necessary.

-Mitch
