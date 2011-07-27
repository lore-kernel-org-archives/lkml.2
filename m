Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab1G0X4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 19:56:33 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39512 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab1G0X4b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 19:56:31 -0400
MIME-Version: 1.0
In-Reply-To: <201107272247.50613.kernelmail.jms@gmail.com>
References: <20110719224142.GT2357@linux.vnet.ibm.com> <CAM=x7SYYSPGhqYmEAUqe6pc2N=Djg-aG31P5nSmPGDsMORBmyA@mail.gmail.com>
 <20110722022937.GB2408@linux.vnet.ibm.com> <201107272247.50613.kernelmail.jms@gmail.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Wed, 27 Jul 2011 19:56:10 -0400
Message-ID: <CAGZ=bq+p0kNuj-2dAj40D1Hdru-S64vE_QEhL_mAphYY-0hqyw@mail.gmail.com>
Subject: Re: Fw: RCU boot debug patch
To: kernelmail.jms@gmail.com
Cc: paulmck@linux.vnet.ibm.com, RKK <kulkarni.ravi4@gmail.com>,
        linux-kernel@vger.kernel.org, cmm@us.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 17:47,  <kernelmail.jms@gmail.com> wrote:
>>A debug patch to verify if there is RCU callbacks before the rcu scheduler is active
> So something gives me the impression we may have an answer somewhere in this dmesg for this... ;-)
>
> Here is my dmesg (the whole thing):
>
> function free_object_rcu
> [    0.166707] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu
> [....thousands of lines snipped...]
> [    0.225223] RCU scheduler is not active yet, Calling _call_rcu() with this function free_object_rcu

Well this looks an awful lot like a smoking gun here...

I can only find one function called "free_object_rcu", and it seems to be a
static function in mm/kmemleak.c, and it certainly does this:
   call_rcu(&object->rcu, free_object_rcu);

So the next question for you would be:  Do all the messages go away if you
turn off the kmemleak config option?

Cheers,
Kyle Moffett
