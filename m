Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139Ab1IIJIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 05:08:11 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:48396 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933090Ab1IIJIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 05:08:10 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E69D968.2020100@cam.ac.uk>
Date: Fri, 09 Sep 2011 10:16:24 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110901 Thunderbird/6.0
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Donggeun Kim <dg77.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, akpm@linux-foundation.org, jic23@cam.ac.kr,
        kyungmin.park@samsung.com
Subject: Re: [PATCH v2] misc: Add driver for GP2AP002 proximity/ambient light
 sensor
References: <1315556546-7445-1-git-send-email-dg77.kim@samsung.com> <20110909083134.GA21835@suse.de>
In-Reply-To: <20110909083134.GA21835@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/11 09:31, Greg KH wrote:
> On Fri, Sep 09, 2011 at 05:22:26PM +0900, Donggeun Kim wrote:
>> SHARP GP2AP002 is proximity and ambient light sensor.
>> This patch supports it.
>>
>> Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>> Changes for v2
>>   - changed to expose lux
>>   - changed request_irq to request_threaded_irq function
>>   - added sysfs_notify function call
> 
> Why?  You should never do that unless you _really_ know what you are
> doing.
My bad.  I suggested it was a better bet than doing a uevent to act
as a data ready notifier...

Greg, for future reference can you clarify why it's a bad idea or
give a reference (if it's been clarified elsewhere and I missed it!)
> 
> 
>>   - cleaned up code
>>
>>  Documentation/misc-devices/gp2ap002    |   44 +++
>>  drivers/misc/Kconfig                   |   10 +
>>  drivers/misc/Makefile                  |    1 +
>>  drivers/misc/gp2ap002.c                |  488 ++++++++++++++++++++++++++++++++
>>  include/linux/platform_data/gp2ap002.h |   69 +++++
> 
> 
> Shouldn't this be an iio driver instead of some random misc driver with
> an undocumented sysfs file (hint, use Documentation/ABI for documenting
> stuff...) ?
Would certainly be welcome in IIO. We have a couple of similar sensors in there already.
I'm just aware some people/firms are really anti having
their drivers in staging (because the subsystem is there rather than because of issues
in the driver.
