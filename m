Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab1IFOUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 10:20:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:47028 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322Ab1IFOUJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 10:20:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,338,1312182000"; 
   d="scan'208";a="49482751"
From: "Nallasellan, Singaravelan" <singaravelan.nallasellan@intel.com>
To: Arjan van de Ven <arjan@infradead.org>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 6 Sep 2011 19:49:35 +0530
Subject: RE: Player Thread is not woken after period elapsed
Thread-Topic: Player Thread is not woken after period elapsed
Thread-Index: Acxr+E+7B0E9ShsgR9yHhSUoJBu5MQApyKgg
Message-ID: <3CA6C6D9F70D314CA34352990B57DA1507C4275D58@bgsmsx502.gar.corp.intel.com>
References: <3CA6C6D9F70D314CA34352990B57DA1507C420F147@bgsmsx502.gar.corp.intel.com>
	<20110905105253.2787b91f@infradead.org>
	<3CA6C6D9F70D314CA34352990B57DA1507C420F15C@bgsmsx502.gar.corp.intel.com>
 <20110905112225.72b46ac9@infradead.org>
In-Reply-To: <20110905112225.72b46ac9@infradead.org>
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

> please do not top post!
> 
Ok. 
> correcting that mistake for you for this time
> 
Thanks so much.
> 
> >> > User thread which invokes the writei function which in turn invokes
> >> > a kernel function which waits for the free buffer to write the
> >> > audio data.  This kernel function adds this thread to a
> >> > wake(sleep) queue and calls a schedule_timeout
> >> > (msecs_to_jiffies(10000)).
> >
> >> actually it doesn't... you must be on some really really old kernel
> >> or something.
> >>
> 
> > Sorry, I have not provided the kernel version. Kernel version is
> > 2.6.35.
> 
> Please always test bugs like this with a recent kernel. 2.6.35 is pretty much 6
> versions (and 18 months) behind and at that point you really have to test with
> something newer first before asking others to help you and spend their time on
> your problem.
> 
Unfortunately, I am stuck with that version as the product that I work on is on that version. 
> 
> >> > Will you provide some hint on how to go about identifying the root
> >> > cause?
> 
> >> https://lkml.org/lkml/2011/9/5/201
> 
I manually ported the changes and verified. I still see the issue. Found more information which might throw more light into the problem. 
p->state in try_to_wake_up() is 0 when it is expected to be 2 or 3.

> > However, wait_for_avail() does not have the code similar to the one
> > provided in the patch below.
> 
> the patch is against a recent kernel; no surprise that the code has changed in the
> last 18 months....
> 
> 
> --
> Arjan van de Ven 	Intel Open Source Technology Centre
> For development, discussion and tips for power savings, visit
> http://www.lesswatts.org
