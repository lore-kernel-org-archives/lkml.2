Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750945Ab0KDNdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 09:33:18 -0400
Received: from smtp.nokia.com ([192.100.122.233]:64838 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab0KDNdQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 09:33:16 -0400
From: <samu.p.onkalo@nokia.com>
To: <gregkh@suse.de>
CC: <hmh@hmh.eng.br>, <alan@linux.intel.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Date: Thu, 4 Nov 2010 14:32:15 +0100
Subject: RE: [PATCH] sysfs: device-core: sysfs open close notify
Thread-Topic: [PATCH] sysfs: device-core: sysfs open close notify
Thread-Index: Act8JAbVi2LIYxN3TLy2EmcUCWuuogAADsTw
Message-ID: <62697B07E9803846BC582181BD6FB6B836EB63CB54@NOK-EUMSG-02.mgdnok.nokia.com>
References: <1288861417-469-1-git-send-email-samu.p.onkalo@nokia.com>
 <20101104132339.GC10390@suse.de>
In-Reply-To: <20101104132339.GC10390@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 04 Nov 2010 13:32:18.0230 (UTC) FILETIME=[B37EF560:01CB7C24]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: ext Greg KH [mailto:gregkh@suse.de]
>Sent: 04 November, 2010 15:24
>To: Onkalo Samu.P (Nokia-MS/Tampere)
>Cc: hmh@hmh.eng.br; alan@linux.intel.com; akpm@linux-foundation.org;
>linux-kernel@vger.kernel.org
>Subject: Re: [PATCH] sysfs: device-core: sysfs open close notify
>
>On Thu, Nov 04, 2010 at 11:03:37AM +0200, Samu Onkalo wrote:
>> Patch adds possibility for a driver to get open and close
>> notifications from the sysfs accesses. Driver may need this
>> information for enabling features and for runtime
>> power management control.
>>
>> Patch causes quite small overhead compared to current implementation.
>> Sysfs_ops is enhanced with open_close notify method which causes
>> some increase to static memory consumption. Sysfs attribute defition
>> is not changed.
>>
>> Device core is modified with open_close_notification function and
>> corresponding sysfs_ops change. New macro is introduced which can
>> be used to setup sysfs attributes with open_close notification
>> in a device driver.
>>
>> Sysfs control itself contains new optional calls to open_close_
>> notifications and a function which controls the feature.
>> By default nothing it changed at runtime.
>>
>> Normal sysfs creation and remove functions can be used to control
>> attributes in device drivers.
>>
>> Change needed device drivers:
>> For sysfs attributes which needs open_close_notification:
>> Use DEVICE_ATTR_NOTIFY instead of DEVICE_ATTR with sysfs attributes.
>> Call sysfs_set_open_notify for those attributes after the creation.
>
>Can you somehow not have to make the extra call to
>sysfs_set_open_notify?  The driver doesn't want to dig down and find the
>kobject, and shouldn't have to do this.  Also, it will race with the
>creation of the sysfs file and userspace opening the file before the
>driver has the ability to set this marking on the file, so the driver
>could never be notified of the original open and everyone involved will
>be confused.
>

Yes, this extra call is somehow problematic as you wrote.
It is easy to get rid of if the mode parameter is used to pass the information
that this entry uses open_close_notify.  What do you think, is it ok to use
mode also to that purpose?

-Samu





