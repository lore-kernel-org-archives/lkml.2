Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab0IODOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 23:14:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:55215 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587Ab0IODOV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 23:14:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,368,1280732400"; 
   d="scan'208";a="554565149"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>,
        "jdike@linux.intel.com" <jdike@linux.intel.com>
Date: Wed, 15 Sep 2010 11:13:44 +0800
Subject: RE: [RFC PATCH v9 12/16] Add mp(mediate passthru) device.
Thread-Topic: [RFC PATCH v9 12/16] Add mp(mediate passthru) device.
Thread-Index: ActSgHWmIA4SbTyYSWO0Z3ZqMONSqgCAzBvw
Message-ID: <F2E9EB7348B8264F86B6AB8151CE2D792B8C815365@shsmsx502.ccr.corp.intel.com>
References: <1281086624-5765-8-git-send-email-xiaohui.xin@intel.com>
 <1281086624-5765-9-git-send-email-xiaohui.xin@intel.com>
 <1281086624-5765-10-git-send-email-xiaohui.xin@intel.com>
 <1281086624-5765-11-git-send-email-xiaohui.xin@intel.com>
 <1281086624-5765-12-git-send-email-xiaohui.xin@intel.com>
 <1281086624-5765-13-git-send-email-xiaohui.xin@intel.com>
 <1281086624-5765-14-git-send-email-xiaohui.xin@intel.com>
 <20100906111126.GA15608@redhat.com>
 <F2E9EB7348B8264F86B6AB8151CE2D79280489A9C9@shsmsx502.ccr.corp.intel.com>
 <F2E9EB7348B8264F86B6AB8151CE2D79280489AA05@shsmsx502.ccr.corp.intel.com>
 <20100912133703.GJ22982@redhat.com>
In-Reply-To: <20100912133703.GJ22982@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Michael S. Tsirkin [mailto:mst@redhat.com]
>Sent: Sunday, September 12, 2010 9:37 PM
>To: Xin, Xiaohui
>Cc: netdev@vger.kernel.org; kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>mingo@elte.hu; davem@davemloft.net; herbert@gondor.hengli.com.au;
>jdike@linux.intel.com
>Subject: Re: [RFC PATCH v9 12/16] Add mp(mediate passthru) device.
>
>On Sat, Sep 11, 2010 at 03:41:14PM +0800, Xin, Xiaohui wrote:
>> >>Playing with rlimit on data path, transparently to the application in this way
>> >>looks strange to me, I suspect this has unexpected security implications.
>> >>Further, applications may have other uses for locked memory
>> >>besides mpassthru - you should not just take it because it's there.
>> >>
>> >>Can we have an ioctl that lets userspace configure how much
>> >>memory to lock? This ioctl will decrement the rlimit and store
>> >>the data in the device structure so we can do accounting
>> >>internally. Put it back on close or on another ioctl.
>> >Yes, we can decrement the rlimit in ioctl in one time to avoid
>> >data path.
>> >
>> >>Need to be careful for when this operation gets called
>> >>again with 0 or another small value while we have locked memory -
>> >>maybe just fail with EBUSY?  or wait until it gets unlocked?
>> >>Maybe 0 can be special-cased and deactivate zero-copy?.
>> >>
>>
>> How about we don't use a new ioctl, but just check the rlimit
>> in one MPASSTHRU_BINDDEV ioctl? If we find mp device
>> break the rlimit, then we fail the bind ioctl, and thus can't do
>> zero copy any more.
>
>Yes, and not just check, but decrement as well.
>I think we should give userspace control over
>how much memory we can lock and subtract from the rlimit.
>It's OK to add this as a parameter to MPASSTHRU_BINDDEV.
>Then increment the rlimit back on unbind and on close?
>
>This opens up an interesting condition: process 1
>calls bind, process 2 calls unbind or close.
>This will increment rlimit for process 2.
>Not sure how to fix this properly.
>
I can't too, can we do any synchronous operations on rlimit stuff?
I quite suspect in it.
 
>--
>MST
