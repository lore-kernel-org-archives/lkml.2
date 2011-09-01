Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab1IAIxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 04:53:30 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:59986 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756532Ab1IAIx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 04:53:28 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E5F49F4.2080208@cam.ac.uk>
Date: Thu, 01 Sep 2011 10:01:40 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110801 Thunderbird/5.0
MIME-Version: 1.0
To: Andrew Chew <AChew@nvidia.com>
CC: Stephen Warren <swarren@nvidia.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 1/3] staging:iio:magnetometer:ak8975 Don't use irq_to_gpio()
References: <1314819657-828-1-git-send-email-swarren@nvidia.com> <643E69AA4436674C8F39DCC2C05F76383CF3C784A3@HQMAIL03.nvidia.com>
In-Reply-To: <643E69AA4436674C8F39DCC2C05F76383CF3C784A3@HQMAIL03.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/11 20:45, Andrew Chew wrote:
>> Subject: [PATCH 1/3] staging:iio:magnetometer:ak8975 Don't 
>> use irq_to_gpio()
>>
>> Tegra doesn't have irq_to_gpio() any more, and ak8975 is included in
>> tegra_defconfig. This causes a build failure. Solve this with 
>> a heavy-handed
>> method for now.
>>
>> I suspect the long-term solution is to pass both the IRQ and GPIO IDs
>> to the driver; the GPIO ID coming from either platform data, 
>> or perhaps
>> enhancing struct i2c_client to add a gpio field alongside irq.
>>
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>> ---
> 
> The three patches in this set LGTM.
> 
> Acked-by: Andrew Chew <achew@nvidia.com> 
> 

Hmm.. I'd like to see some means of passing that in. Perhaps as simple as passing
a pointer to an int in as platform_data.  Patch to follow.
