Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab0DOK3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 06:29:33 -0400
Received: from ppsw-32.csi.cam.ac.uk ([131.111.8.132]:52205 "EHLO
	ppsw-32.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab0DOK3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 06:29:31 -0400
X-Greylist: delayed 1380 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Apr 2010 06:29:31 EDT
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4BC6E5CF.9070302@jic23.retrosnub.co.uk>
Date: Thu, 15 Apr 2010 11:09:19 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: isl29020: ALS driver as misc device
References: <20100414124913.23181.75903.stgit@localhost.localdomain> <20100414125136.23181.16788.stgit@localhost.localdomain> <4BC5C7A8.1040807@cam.ac.uk> <20100414153234.22765666@lxorguk.ukuu.org.uk> <4BC5D681.20707@jic23.retrosnub.co.uk> <20100414175602.44580f3c@lxorguk.ukuu.org.uk> <20100414170153.GA7494@kroah.com>
In-Reply-To: <20100414170153.GA7494@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/10 18:01, Greg KH wrote:
> On Wed, Apr 14, 2010 at 05:56:02PM +0100, Alan Cox wrote:
>> And this adds the isl29020 as a misc device per discussions
>>
>> isl29020: ambient light sensor
>>
>> From: Kalhan Trisal <kalhan.trisal@intel.com>
>>
>> The LS driver will read the latest Lux measurement based upon the
>> light brightness and will report the LUX output through sysfs interface.
> 
> Please document this sysfs interface with an addition to the
> Documentatin/ABI/ directory.
As documenting this abi (which indeed should be done) is going to set
a precedence, perhaps this is a good time to discuss what this naming could
be.

In cleaning up the IIO abi Greg suggested that we match existing similar
abi's a closely as possible, which where possible makes a great deal of sense
(shared userspace code is possible and it makes everything a bit more predictable
for driver writers... particularly as I expect someone will sooner or later
make a combined hwmon and als chip).

The obvious similarity here is with hwmon.
So perhaps going with naming as

lux-> illuminance0_input  (or I guess lux0_input would also work, I can change
the iio abi to match this as well).

It also occurs to me that we might want to associate the calibration with the
particular channel? There's sure to be a dual ALS chip along at some point.

Obviously the isl29020 would need updating as well.  Everyone was happy to do
that when were writing the ALS subsystem, so I guess that won't have changed!

Jonathan
