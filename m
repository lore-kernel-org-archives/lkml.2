Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761144Ab2KAACW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 20:02:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:24948 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295Ab2KAACU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 20:02:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,688,1344236400"; 
   d="scan'208";a="211986750"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Oliver Neukum <oneukum@suse.de>
CC: "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] alarmtimer: Replace the spinlock rtcdev_lock with
 mutex
Thread-Topic: [PATCH 1/3] alarmtimer: Replace the spinlock rtcdev_lock with
 mutex
Thread-Index: AQHNt0aZzAGtvCioQUWDDoOWqLpdN5fUGTEA
Date: Thu, 1 Nov 2012 00:02:13 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A1B9C8A@SHSMSX101.ccr.corp.intel.com>
References: <1351700455.15558.1571.camel@cliu38-desktop-build>
 <2035297.QqCM5sVoD5@linux-lqwf.site>
In-Reply-To: <2035297.QqCM5sVoD5@linux-lqwf.site>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Oliver Neukum [mailto:oneukum@suse.de]
> Sent: Wednesday, October 31, 2012 5:03 PM
> To: Liu, Chuansheng
> Cc: john.stultz@linaro.org; tglx@linutronix.de; gregkh@linuxfoundation.org;
> linux-kernel@vger.kernel.org; Liu, Chuansheng
> Subject: Re: [PATCH 1/3] alarmtimer: Replace the spinlock rtcdev_lock with
> mutex
> 
> On Thursday 01 November 2012 00:20:55 Chuansheng Liu wrote:
> > When do code reviewing, found no special requirement to
> > use spin_lock_irqsave/spin_unlock_irqrestore, because
> > alarmtimer_get_rtcdev() is called by posix clock interface.
> > So would like to use mutex to replace it.
> 
> What is gained thereby?
spin_lock_irqsave will disable the preempt and local irq, it is expensive than
mutex. Thanks.
> 
> 	Regards
> 		Oliver

